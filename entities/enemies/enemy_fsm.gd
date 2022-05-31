class_name EnemyFSM
extends StateMachine
# This class must override the _change_state method to exit the current
# state, do the necessary steps and finally switch to the new state.
# Also, the states_map dictionary will contain all the states' names as
# keys and their path as the relative entry. Each id will be referenced
# from each state and passed on when their "finished" signal is emitted.


const STATES_STACK_COUNT := 2


# We need to add states to states_map. It will look like this:
#	states_map = {
#		"move": $Move,
#		"idle": $Idle,
#		"hit": $Hit,
#	}
func _ready() -> void:
	for node in get_children():
		states_map[String(node.name).to_lower()] = node


# Special case to force a switch to the Hit state.
# Called when colliding with damaging objects. This is a limitation of
# this implementation because we can't pass data directly to a state.
# TODO: try finding a way to let the Hit state handle damage.
func is_hit(damage: int) -> void:
	if current_state.name == "Hit":
		print("Already in Hit state")
		return
	(owner as Enemy).take_damage(damage)
	current_state.emit_signal("finished", "hit")


func _change_state(state_name: String) -> void:
	# exit the current state
	current_state.exit()
	states_stack.push_front(states_map[state_name])
	if states_stack.size() > STATES_STACK_COUNT:
		states_stack.pop_back()
	# enter the new one
	current_state = states_stack[0]
	emit_signal("state_changed", states_stack)
	current_state.enter()
