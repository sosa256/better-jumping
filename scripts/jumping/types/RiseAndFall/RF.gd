### Rise and Fall (2 curves)
## DESCRIPTION
# Adds detail to the jump.
# Curves switch at the peak of a jump.
#
# Will need a graph to visualize your jump trajectory.
# Graph: https://www.desmos.com/calculator/ngsa4tpciw
# First set max height and max distance. (both the guidelines and the actual data)
# Then change m_rise to see the jump trajectory (rise & fall curve) change.

tool
extends KinematicBody2D
class_name Jumping_RF




## DATA
# All the curves you will need.
var rise_curve := JumpCurve.new()
var fall_curve := JumpCurve.new()

# Refer to JumpCurve.gd script for description of curve types.
enum curve_types {BASE, RISE, FALL, EARLY_RELEASE}

# Jump properties. (exposed)
# Units are in pixels.
var max_lateral_speed := 420 setget set_max_lateral_speed, get_max_lateral_speed
var max_jump_height   := 420 setget   set_max_jump_height, get_max_jump_height
var max_distance      := 420 setget      set_max_distance, get_max_distance
var rise_distance     := 420
var fall_distance     := 420 # Calculated on update_variables.

# States to figure out which gravity to use.
# falling_states: 
# STANDING - On the ground
# RISING - Going up the curve
# FALLING - Going down the curve
enum falling_states {STANDING, RISING, FALLING}

var curr_fall_state = falling_states.STANDING     setget set_curr_fall_state, get_curr_fall_state
var prev_fall_state:int = falling_states.STANDING setget set_prev_fall_state, get_prev_fall_state




## FUNCTIONS
func _ready():
	# Print the details of the curves.
	print(rise_curve)
	print(fall_curve)
	print("\n")


# Decides the falling state based on y-velocity.
# Positive numbers means we are going down in Godot.
func find_fall_state( player_vel:Vector2 ) -> int:
	if player_vel.y < 0:
		# We are going up
		return falling_states.RISING

	if player_vel.y > 0:
		# We are going down.
		return falling_states.FALLING

	# So y == 0
	if prev_fall_state == falling_states.RISING:
		# We are at the peak.
		# Treat as falling.
		return falling_states.FALLING

	# We are not moving.
	return falling_states.STANDING


# Current fall_state is saved before it changes
	# This has to happen before setting the gravity for
	# jumps with more than one curve or it'll severely cut your gravity. 
	# I don't know the specifics but that's what happens.
func update_fall_states(player_vel:Vector2) -> void:
	set_prev_fall_state( get_curr_fall_state() )
	set_curr_fall_state( find_fall_state(player_vel) )


# A gravity is picked depending on the state.
# The y component will not be 0 (zero) after this method.
func pick_gravity() -> float:
	# Gravity will switch at the peak of the jump.
	if (curr_fall_state == falling_states.STANDING) || (curr_fall_state == falling_states.RISING):
		return rise_curve.get_gravity()
	else:
		return fall_curve.get_gravity()


# Gravity is applied.
func apply_gravity( player_vel:Vector2, _delta:float ) -> Vector2:
	update_fall_states(player_vel)
	player_vel.y += pick_gravity() * _delta
	return player_vel


func jump(player_vel:Vector2) -> Vector2:
#	print("Debug: Inital Velocity applied")
	player_vel.y = ( rise_curve.get_inital_velocity() )
	return player_vel




## SET / GET FUNCTIONS (from setgets)
func set_max_lateral_speed(value:int) -> void:
	max_lateral_speed = value

func get_max_lateral_speed() -> int:
	return max_lateral_speed


func set_max_jump_height(value:int) -> void:
	max_jump_height = value

func get_max_jump_height() -> int:
	return max_jump_height


func set_max_distance(value:int) -> void:
	max_distance = value

func get_max_distance() -> int:
	return max_distance


func set_curr_fall_state(value) -> void:
	curr_fall_state = value

func get_curr_fall_state() -> int:
	return curr_fall_state


func set_prev_fall_state(value) -> void:
	prev_fall_state = value

func get_prev_fall_state() -> int:
	return prev_fall_state




## EDITOR FUNCTIONS
# Properties to show in the editor
var exposed_properties := {
	"Jump Stats/Lateral Speed (max)": max_lateral_speed,
	"Jump Stats/Height (max)":  max_jump_height,
	"Jump Stats/Distance (max)":   max_distance,
	"Jump Stats/Distance (rise)": rise_distance,
}


# Updates whenever the editor values change.
func update_variables():
	# Update the individual properties.
	set_max_lateral_speed( exposed_properties["Jump Stats/Lateral Speed (max)"] )
	set_max_jump_height( exposed_properties["Jump Stats/Height (max)"] )
	set_max_distance( exposed_properties["Jump Stats/Distance (max)"] )
	rise_distance = exposed_properties["Jump Stats/Distance (rise)"]
	fall_distance = ( max_distance - ( rise_distance/2 ) ) * 2

	# Update curves with new properties.
	rise_curve.initalize_variables(curve_types.RISE, get_max_jump_height(), rise_distance, get_max_lateral_speed())
	fall_curve.initalize_variables(curve_types.FALL, get_max_jump_height(), fall_distance, get_max_lateral_speed())


# Will define the order in which the properties will appear in the editor.
func _get_property_list() -> Array:
	var property_arr := []

	property_arr.append({
		"name": "Jump Stats/Lateral Speed (max)",
		"type": TYPE_INT,
	})

	property_arr.append({
	"name": "Jump Stats/Distance (max)",
	"type": TYPE_INT,
	})

	property_arr.append({
		"name": "Jump Stats/Height (max)",
		"type": TYPE_INT,
	})

	property_arr.append({
		"name": "Jump Stats/Distance (rise)",
		"type": TYPE_INT,
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
			# This conditional was used for a different version of this project.
			# if(prop_name == "Number of Curves Used In Graph"):
				# property_list_changed_notify()

	return property_exists


# Editor gets the values to display.
func _get(prop_name: String):
	for i in exposed_properties.keys():
		if (i == prop_name):
			return exposed_properties[prop_name]

	return null

