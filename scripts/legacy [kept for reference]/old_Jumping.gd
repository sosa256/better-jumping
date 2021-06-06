# This version was an attempt to squish all the functionality into one script.
# Needless to say this was not a good idea.
# It was hard to read, debug, and organize.
# I'm holding on to it just in case.
# I'll delete it eventually.




# # Dependencies:
# # - JumpCurveObj script

# # Lemme explain:
# # - This is only meant to hold functions for an inherited
# #	class to use and to encapsulate curve data
# # - You will still need to graph your jump but now
# #	all you have to do is place the bare minimum and 
# #	the values will be calculated and stored for later use
# # - Only the BASE will use the "max_distance" the rest 
# #	will need their own "max_distance" from your graph

# # Units are in pixles
# tool
# extends KinematicBody2D
# class_name Jumping


# # All the curves you will need.
# var base_curve := JumpCurve.new()
# var rise_curve := JumpCurve.new()
# var fall_curve := JumpCurve.new()
# var early_release_curve := JumpCurve.new()

# # Refer to JumpCurveObj script for description
# enum curve_types {BASE, RISE, FALL, EARLY_RELEASE}

# # Jump properties. (exposed)
# var max_lateral_speed := 420 setget set_max_lateral_speed, get_max_lateral_speed
# var max_jump_height   := 420 setget   set_max_jump_height, get_max_jump_height
# var min_jump_height   := 420 setget   set_min_jump_height, get_min_jump_height
# var max_distance      := 420 setget      set_max_distance, get_max_distance
# var rise_distance     := 420
# var fall_distance     := 420
# var early_release_distance := 420

# # Movement properties.
# var friction = 0.1
# var acceleration = 0.25

# # States to figure out which gravity to use.
# # falling_states: 
# # NOT_FALLING - On the ground
# # RISING - Going up the curve
# # RISE_EARLY_FALLING - Released jump before reaching the peak
# # COMPLETE_EARLY_FALLING -  Released jump after reaching the peak
# # COMPLETE_FALLING - Jump button is held 
# enum falling_states {NOT_FALLING, RISING, RISE_EARLY_FALLING, COMPLETE_EARLY_FALLING, COMPLETE_FALLING}
# var player_fall_state = falling_states.NOT_FALLING setget set_player_fall_state, get_player_fall_state

# var previous_fall_state:int = falling_states.NOT_FALLING

# # Jumping curves data.
# var curves_used_in_graph = 1   setget set_curves_used, get_curves_used
# var curves_arr := [base_curve]   setget  set_curves_arr, get_curves_arr


# # Decides the falling state based on y-velocity and wether or not
# # the jump buton is held.
# func find_falling_state( p_velocity:Vector2 ):
	# if (curves_used_in_graph == 3):
		# # I think I finally got this working.
		# # Test more thoroughly with differnt curves.
		 
		# # Positive numbers means we are going down.
		# if p_velocity.y == 0:
			# # We are not moving.
			# return falling_states.NOT_FALLING
		
		# # Are we moving.
		# if Input.is_action_pressed("jump"):
			# # The jump button held so we must travel on the default path.
			# if p_velocity.y < 0:
				# # We are going up.
				# return falling_states.RISING
			
			# # We are going down
			# return falling_states.COMPLETE_FALLING
		
		# # The button is not held so we must be falling.
		# if (previous_fall_state == falling_states.RISING) || (previous_fall_state == falling_states.RISE_EARLY_FALLING):
			# # We let go of the button while rising. 
			# return falling_states.RISE_EARLY_FALLING
		
		# # We let go of the button while falling.
		# # The boolean expression would of been ( prev_state is CF or CEF ). 
		# return falling_states.COMPLETE_EARLY_FALLING
		
	# else:
		# # Positive numbers means we are going down.
		# if p_velocity.y > 0:
			# # We are going up.
			# return falling_states.COMPLETE_FALLING
		
		# if p_velocity.y < 0:
			# # We are going down
			# return falling_states.RISING
		
		# # We are not moving ( p_velocity.y == 0 )
		# # This could also happen right at the peak.
		# # Tighten this up by comparing last known fall state.
		# return falling_states.NOT_FALLING


# # Gravity is applied.
# func apply_gravity( p_velocity:Vector2, _delta:float ) -> Vector2:
	# var forces:Vector2 = pick_gravity(p_velocity)
	
	# if forces.x != 0:
		# p_velocity.y = forces.x
	
	# p_velocity.y += forces.y * _delta
	
	
	# return p_velocity



# # A gravity is picked depending on the state.
# func pick_gravity( p_velocity:Vector2 ) -> Vector2:
	# # This has to happen before setting the gravity for
	# # jumps with more than one curve or it'll severely cut your gravity. 
	# # I don't know the specifics but that's what happens.
	# # Another thing I noted. The velocity can be (0,0) going in the
	# # find_falling_state method but will be assigned a gravity (y componrnt)
	# # at the end of this method. Basically velocity.y can't be 0 after this method.
	
	# # Current fall_state is saved befor it changes
	# #print("Pre\n%s\n%s" % [previous_fall_state, player_fall_state])
	# previous_fall_state = player_fall_state
	# set_player_fall_state( find_falling_state(p_velocity) )
	# #print("After\n%s\n%s\n\n" % [previous_fall_state, player_fall_state])
	# var forces := Vector2.ZERO
	
	# if (curves_used_in_graph == 1):
		# # Gravity will never change.
		# forces.y = get_curve(curve_types.BASE).get_gravity()
		# return ( forces )
	
	# elif (curves_used_in_graph == 2):
		# # Gravity will switch at the peak of the jump.
		# # Debugging message print(get_fall_state_name())
		# if (player_fall_state == falling_states.NOT_FALLING) || (player_fall_state == falling_states.RISING):
			# forces.y = get_curve(curve_types.RISE).get_gravity()
			# return ( forces )
		# else:
			# forces.y = get_curve(curve_types.FALL).get_gravity()
			# return ( forces )
	
	# # We must be using 3 curves if we made it here.
	# if (player_fall_state == falling_states.NOT_FALLING) || (player_fall_state == falling_states.RISING):
			# forces.y = get_curve(curve_types.RISE).get_gravity()
			# return ( forces )
	# elif player_fall_state == falling_states.COMPLETE_FALLING:
		# forces.y = get_curve(curve_types.FALL).get_gravity()
		# return ( forces )
	
	# # This is a complete mess. 
	# # Position assumes we jumped at height zero.
	# # We are not meeting the minimum jump height.
	# # Fix later.
	
	# # We are falling early and have to adjust the y velocity
	# if (previous_fall_state == falling_states.RISING) || (previous_fall_state == falling_states.COMPLETE_FALLING):
		# print("I should only be called once ")
		# forces.x =get_curve(curve_types.EARLY_RELEASE).calculate_current_y_velocity(position.y * -1)
		# print(forces.x)

	# forces.y = get_curve(curve_types.EARLY_RELEASE).get_gravity()
	
	# return ( forces )
	
	
	# # Rewrite this cause it doesn't work
	# #return null
# #	if player_fall_state == falling_states.COMPLETE_FALLING:
# #		return ( get_curve(curve_types.FALL).get_gravity() ) #fall_gravity (button is held)
# #	elif player_fall_state == falling_states.EARLY_FALLING:
# #		return ( get_curve(curve_types.EARLY_RELEASE).get_gravity() ) #release_fall_gravity (button let go)
# #	else:
# #		return ( get_curve(curve_types.RISE).get_gravity() ) #normal_gravity for rising and standstill






# # Tool methods


# func get_curve(acurve_type:int) -> JumpCurve:
	# for i in curves_arr:
		# if acurve_type == i.get_curve_type():
			# return i
	# return null


# func _to_string()-> String:
	# var msg = "//Your Jump Curves\\\\"
	# for i in get_curves_arr():
		# msg += "\n%s\n" % i
	# return msg



# # Properties to show in the editor
# var exposed_properties := {
	# "Number of Curves Used In Graph": curves_used_in_graph,
	# "Jump Stats/Lateral Speed (max)": max_lateral_speed,
	# "Jump Stats/Height (max)":  max_jump_height,
	# "Jump Stats/Height (min)":  min_jump_height,
	# "Jump Stats/Distance (max)":   max_distance,
	# "Jump Stats/Distance (rise)": rise_distance,
	# "Jump Stats/Distance (early release)": early_release_distance
# }




# func update_variables(aprop_name:String):
# #	print("updating variables...")
	# set_curves_used( exposed_properties["Number of Curves Used In Graph"] )
	# set_max_lateral_speed( exposed_properties["Jump Stats/Lateral Speed (max)"] )
	# set_max_jump_height( exposed_properties["Jump Stats/Height (max)"] )
	# set_min_jump_height( exposed_properties["Jump Stats/Height (min)"] )
	# set_max_distance( exposed_properties["Jump Stats/Distance (max)"] )
	# rise_distance = exposed_properties["Jump Stats/Distance (rise)"]
	# fall_distance = ( max_distance - ( rise_distance/2 ) ) * 2
	
	# early_release_distance = exposed_properties["Jump Stats/Distance (early release)"]
# #	print("done with variables")
	
	# update_curves_array(aprop_name)
	
# #	print("end\n\n")


# func update_curves_array(aaprop_name:String):
# #	print("updating curves...")
	# if (aaprop_name == "Number of Curves Used In Graph"):
		# curves_arr.clear()
# #		print("1Array of curves size: %s" % get_curves_used() )
		# var num_of_curves = get_curves_used()
		# if (num_of_curves == 1):
# #			print("Using 1")
			# curves_arr.append( base_curve )
			# curves_arr[0].initalize_variables()
		# elif(num_of_curves == 2):
# #			print("Using 2")
			# curves_arr.append( rise_curve )
			# curves_arr.append( fall_curve )
			# curves_arr[0].initalize_variables(curve_types.RISE)
			# curves_arr[1].initalize_variables(curve_types.FALL)
		# else:
# #			print("Using 3")
			# curves_arr.append( rise_curve )
			# curves_arr.append( fall_curve )
			# curves_arr.append( early_release_curve ) 
			# curves_arr[0].initalize_variables(curve_types.RISE)
			# curves_arr[1].initalize_variables(curve_types.FALL)
			# curves_arr[2].initalize_variables(curve_types.EARLY_RELEASE)
# #	print("Array of curves size: %s" % get_curves_used() )
# #	print("done with curves")
	# refresh_curves()


# func refresh_curves() -> void:
# #	print("Refreshing curves...")
	# for i in curves_arr:
		# if i.get_curve_type() == curve_types.BASE:
			# i.initalize_variables(curve_types.BASE, max_jump_height, max_distance, max_lateral_speed)
			
		# elif i.get_curve_type() == curve_types.RISE:
			# i.initalize_variables(curve_types.RISE, max_jump_height, rise_distance, max_lateral_speed)
			
		# elif i.get_curve_type() == curve_types.FALL:
			# i.initalize_variables(curve_types.FALL, max_jump_height, fall_distance, max_lateral_speed)
			
		# else:
			# i.initalize_variables(curve_types.EARLY_RELEASE, min_jump_height, early_release_distance, max_lateral_speed)
# #		print("%s\n\n" % i)
# #	print("done refreshing")


# func _get_property_list() -> Array:
	# var property_arr := []
	
	# property_arr.append({
		# "name": "Number of Curves Used In Graph",
		# "type": TYPE_INT,
		# "hint": PROPERTY_HINT_RANGE,
		# "hint_string": "1,3,1"
	# })
	
	# property_arr.append({
		# "name": "Jump Stats/Lateral Speed (max)",
		# "type": TYPE_INT,
	# })
	
	# property_arr.append({
	# "name": "Jump Stats/Distance (max)",
	# "type": TYPE_INT,
	# })
	
	# property_arr.append({
		# "name": "Jump Stats/Height (max)",
		# "type": TYPE_INT,
	# })
	
	# if (get_curves_used() == 3):
		# property_arr.append({
			# "name": "Jump Stats/Height (min)",
			# "type": TYPE_INT,
		# })
	
	# if (get_curves_used() != 1):
		# property_arr.append({
			# "name": "Jump Stats/Distance (rise)",
			# "type": TYPE_INT,
		# })
		
	
	# if (get_curves_used() == 3):
		# property_arr.append({
			# "name": "Jump Stats/Distance (early release)",
			# "type": TYPE_INT,
		# })
	
	# return property_arr


# # To update property list have an if statement that checks all the conditional properties
# func _set(prop_name: String, val) -> bool:
	# var property_exists: bool = false

	# for i in exposed_properties.keys():
		# if (i == prop_name):
			# property_exists = true
			# exposed_properties[prop_name] = val
			# update_variables(prop_name)
			# if(prop_name == "Number of Curves Used In Graph"):
				# property_list_changed_notify()

	# return property_exists


# # Get property
# func _get(prop_name: String):
	# for i in exposed_properties.keys():
		# if (i == prop_name):
			# return exposed_properties[prop_name]

	# return null




# # Setters / Getters
# func set_max_lateral_speed(value:int) -> void:
	# max_lateral_speed = value

# func get_max_lateral_speed() -> int:
	# return max_lateral_speed


# func set_max_jump_height(value:int) -> void:
	# max_jump_height = value

# func get_max_jump_height() -> int:
	# return max_jump_height


# func set_min_jump_height(value:int) -> void:
	# min_jump_height = value

# func get_min_jump_height() -> int:
	# return min_jump_height


# func set_max_distance(value:int) -> void:
	# max_distance = value

# func get_max_distance() -> int:
	# return max_distance


# func set_player_fall_state(value) -> void:
	# player_fall_state = value

# func get_player_fall_state() -> int:
	# return player_fall_state


# # NOT_FALLING - On the ground
# # RISING - Going up the curve
# # RISE_EARLY_FALLING - Released jump before reaching the peak
# # COMPLETE_EARLY_FALLING -  Released jump after reaching the peak
# # xCOMPLETE_FALLING - Jump button is held 
# func get_fall_state_name() -> String:
	# match get_player_fall_state():
		# falling_states.NOT_FALLING:
			# return "NOT_FALLING"
		# falling_states.RISING:
			# return "RISING"
		# falling_states.RISE_EARLY_FALLING:
			# return "RISE_EARLY_FALLING"
		# falling_states.COMPLETE_EARLY_FALLING:
			# return "COMPLETE_EARLY_FALLING"
		# falling_states.COMPLETE_FALLING:
			# return "COMPLETE_FALLING"
	
	# return "Not possible to be here"

# func get_player_fall_state_str():
	# var count = 0
	# for i in falling_states.keys():
		# if player_fall_state == count:
			# return i
		# count += 1


# func set_curves_used(value:int) -> void:
	# curves_used_in_graph = value
# #	curves_arr.resize(curves_used_in_graph)
# #	print("curves_arr size %s" % curves_arr.size())

# func get_curves_used() -> int:
	# return curves_used_in_graph


# func set_curves_arr(value:Array) -> void:
	# curves_arr = value

# func get_curves_arr() -> Array:
	# return curves_arr


