extends Node
class_name StateMachine

@export var initial_state: State = null

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)).call()

func _ready():
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)

	await owner.ready
	state.enter("")
	
func _transition_to_next_state(target_state_path: String):
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return
		
	var previous_state_path = state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path)
		
func _unhandled_input(event: InputEvent):
	state.handle_input(event)


func _process(delta):
	state.update(delta)


func _physics_process(delta):
	state.physics_update(delta)
		
	
