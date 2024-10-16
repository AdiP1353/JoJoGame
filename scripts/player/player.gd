class_name Player extends CharacterBody2D

@export var max_speed = 180
@export var acceleration = 8
@export var deceleration_rate = 0.7
@export var max_fall_speed = 300

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_fall: float
@export var coyote_time_in_frames = 15

@onready var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -0.1
@onready var jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -0.1
@onready var fall_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_fall)) * -0.1
@onready var jumpbuffer_ray_cast = $JumpBuffer_RayCast
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var coyote_counter = 0
var can_jump = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# An enum of all states that the player can be in
enum States {IDLE, RUNNING, JUMPING, FALLING}


func _ready():
	move_to_target_position(195, 420)
	
	
func _physics_process(delta):
	
	
	velocity.y += get_custom_gravity() * delta
	
	# Apply ground checks (and gravity)
	check_if_grounded()
	check_if_not_grounded(delta)
	
	# Allow character to move
	control_character()


#---------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------
# poop
# Comment 1
# Comment 2


func get_custom_gravity():
	return jump_gravity if velocity.y < 0 else fall_gravity


func set_custom_gravity(new_gravity):
	gravity = new_gravity


func set_normal_gravity():
	set_custom_gravity(ProjectSettings.get_setting("physics/2d/default_gravity"))
	
	
func set_coyote_counter(coyote_time):
	coyote_counter = coyote_time
	
	
	
func control_character():
	# Allows character to move left and right
	if is_on_floor():
		horizontal_move_grounded()
		
	elif not is_on_floor():
		animation_player.stop()
		horizontal_move_aerial()
	
	
	# Handles jump
	if Input.is_action_just_pressed("jump") and can_jump:
		jump()

			
func horizontal_move_grounded():
	## Move left and right
	if Input.is_action_pressed("left"):
		velocity.x -= acceleration
		sprite.flip_h = true
		animation_player.play("PlayerAnimations/Run")
	
	elif Input.is_action_pressed("right"):
		velocity.x += acceleration
		sprite.flip_h = false
		animation_player.play("PlayerAnimations/Run")
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration_rate)
		animation_player.play("PlayerAnimations/Idle")
		
	# Clamps max speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	move_and_slide()
		
func horizontal_move_aerial():
	## Move left and right in the air
	if Input.is_action_pressed("left"):
		velocity.x -= acceleration
		sprite.flip_h = true
	
	elif Input.is_action_pressed("right"):
		velocity.x += acceleration
		sprite.flip_h = false
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration_rate)
		
	# Clamps max speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	move_and_slide()

		
func jump():
	velocity.y = jump_velocity
	animation_player.play("PlayerAnimations/Jump")
	

func handle_hang_time():
	if not is_on_floor() and velocity.y > 0:
		pass
	

func check_if_grounded():
	if is_on_floor():
		can_jump = true
		set_coyote_counter(coyote_time_in_frames)
		

func check_if_not_grounded(_delta):
	# Add the gravity.
	if not is_on_floor():
		can_jump = false
		
		if jumpbuffer_ray_cast.is_colliding():
			can_jump = true
			
		if coyote_counter > 0:
			can_jump = true
			coyote_counter -= 1

func move_to_target_position(x: int, y: int):
	global_position = Vector2(x, y)
