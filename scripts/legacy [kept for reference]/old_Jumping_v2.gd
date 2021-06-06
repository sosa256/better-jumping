### KEPT for legacy reasons
## Units are in pixles
#extends KinematicBody2D
#
#class_name JumpingV2
#
## Refer to JumpCurveObj script for description
#enum curve_types {BASE, RISE, FALL, EARLY_RELEASE}
#
## Jump properties. (exposed)
#var max_lateral_speed := 42 setget set_max_lateral_speed, get_max_lateral_speed
#var max_jump_height   := 75 setget   set_max_jump_height, get_max_jump_height
#var min_jump_height   := 37 setget   set_min_jump_height, get_min_jump_height
#var max_distance      := 30 setget      set_max_distance, get_max_distance
#
## Movement properties.
#var friction = 0.1
#var acceleration = 0.25
#
## States to figure out which gravity to use.
#enum falling_states {NOT_FALLING, EARLY_FALLING, COMPLETE_FALLING}
#var player_fall_state = falling_states.NOT_FALLING setget set_player_fall_state, get_player_fall_state
#
## Jumping curves data.
#var curves_used_in_graph = 1 setget set_curves_used, get_curves_used
##var curves_arr := []
#
#var base_jump:JumpCurve = JumpCurve.new( curve_types.BASE, get_max_jump_height(), get_max_distance(), get_max_lateral_speed() )
#var rise_jump:JumpCurve = JumpCurve.new( curve_types.RISE, get_max_jump_height(), 10, get_max_lateral_speed() )
#var fall_jump:JumpCurve = JumpCurve.new( curve_types.FALL, get_max_jump_height(), 10, get_max_lateral_speed() )
#var early_release_jump:JumpCurve = JumpCurve.new( curve_types.EARLY_RELEASE, get_min_jump_height(), 10, get_max_lateral_speed() )
#
#
#
#
## Decides the falling state based on y-velocity and wether or not
## the jump buton is held.
#func find_falling_state( p_velocity:Vector2 ):
#	print("\nfind_falling_state is used")
#	# When falling
#	if p_velocity.y > 0: 
#		# And "jump" button is let go
#		if not Input.is_action_pressed("jump"): 
#			return falling_states.EARLY_FALLING
#		else:
#			return falling_states.COMPLETE_FALLING
#	# When rising and the "jump" button is let go
#	elif p_velocity.y < 0 && not Input.is_action_pressed("jump"): 
#		return falling_states.EARLY_FALLING
#	else:
#		return falling_states.NOT_FALLING
#
#
## Gravity is applied
#func apply_gravity( p_velocity:Vector2, _gravity:float, _delta:float ) -> Vector2:
#	print("\napply_gravity is used")
#	p_velocity.y += _gravity * _delta
#	return p_velocity
#
#
## A gravity is picked depending on the state.
#func pick_gravity():
#	print("\npick_gravityis used")
#	if player_fall_state == falling_states.COMPLETE_FALLING:
#		return (base_jump.get_gravity() * -1) #fall_gravity
#	elif player_fall_state == falling_states.EARLY_FALLING:
#		return (base_jump.get_gravity() * -1) #release_fall_gravity
#	else:
#		return (base_jump.get_gravity() * -1) #normal_gravity
#
#
#
#
## Setters / Getters
#func set_max_lateral_speed(value:int) -> void:
#	max_lateral_speed = value
#
#func get_max_lateral_speed() -> int:
#	return max_lateral_speed
#
#
#func set_max_jump_height(value:int) -> void:
#	max_jump_height = value
#
#func get_max_jump_height() -> int:
#	return max_jump_height
#
#
#func set_min_jump_height(value:int) -> void:
#	min_jump_height = value
#
#func get_min_jump_height() -> int:
#	return min_jump_height
#
#
#func set_max_distance(value:int) -> void:
#	max_distance = value
#
#func get_max_distance() -> int:
#	return max_distance
#
#
#func set_player_fall_state(value) -> void:
#	player_fall_state = value
#
#func get_player_fall_state():
#	return player_fall_state
#
#
#func set_curves_used(value:int) -> void:
#	curves_used_in_graph = value
##	curves_arr.resize(curves_used_in_graph)
##	print("curves_arr size %s" % curves_arr.size())
#
#func get_curves_used() -> int:
#	return curves_used_in_graph
#
#
