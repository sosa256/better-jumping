### Coyote Time for 2D Platforming
## DESCRIPTION
# "Slight delay before consequences manifest" from Urban Dictionary
# Allows for smoother gameplay.
# 
# This script should be attached to a node.
# That node should be attached to the player.
# player_node
#   |-> coyote_time_node (script on here)

tool
extends Node
class_name CoyoteTime




## DATA
var coyote_time := 0.1 # sec
var prev_y_vel := 0.0 # px/sec^2
var can_coyote_jump := true




## FUNCTIONS
# Disable coyote jumping while on the floor.
func coyote_is_on_floor(is_on_floor:bool):
	if is_on_floor:
		can_coyote_jump = false


# When falling w/o jumping (ex: slipping off an edge) call coyote_time.
# Make sure the y velocity can actually turns to zero when on the floor.
# y velocity should not be affected by gravity yet.
func coyote_wo_falling(curr_y_velocity:float):
	if (curr_y_velocity > 0) && (prev_y_vel == 0):
		enable_coyote_time()
	update_prev_vel(curr_y_velocity)


# Enables can_coyote_jump briefly
func enable_coyote_time():
	can_coyote_jump = true
	yield(get_tree().create_timer(coyote_time), "timeout")
	can_coyote_jump = false


func update_prev_vel(expired_y_vel:float):
	prev_y_vel = expired_y_vel




## EDITOR FUNCTIONS
# Properties to show in the editor
var exposed_properties := {
	"Coyote Time (ms)": coyote_time
}


# Updates whenever the editor values change.
func update_variables():
	coyote_time = exposed_properties["Coyote Time (ms)"]


# Will define the order in which the properties will appear in the editor.
func _get_property_list() -> Array:
	var property_arr := []
	
	property_arr.append({
		"name": "Coyote Time (ms)",
		"type": TYPE_REAL,
	})
	
	return property_arr


# To update number of elements in property list,
# have an if statement that checks all the conditional properties.
func _set(prop_name: String, val) -> bool:
	var property_exists: bool = false

	for i in exposed_properties.keys():
		if (i == prop_name):
			property_exists = true
			exposed_properties[prop_name] = val
			update_variables()

	return property_exists


# Editor gets the values to display.
func _get(prop_name: String):
	for i in exposed_properties.keys():
		if (i == prop_name):
			return exposed_properties[prop_name]

	return null

