extends Node2D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _input(event: InputEvent):
	if event.is_action_pressed("reload") and OS.is_debug_build():
		if not OS.is_debug_build():
			return
		get_tree().reload_current_scene.call_deferred()
		
	var debug_choice = int(event.as_text())
	
	match debug_choice:
		1:
			give_player_info()
	
	
	
	
	
	

func give_player_info():
	print("-------------------------------------")
	print("Player Node Count: ", player.get_child_count())
	print("Current Animation: ", player.animation_player.current_animation)
	print("-------------------------------------")
	
