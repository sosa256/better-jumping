# This version was an attempt to squish all the functionality into one script.
# Needless to say this was not a good idea.
# It was hard to read, debug, and organize.
# I'm holding on to it just in case.
# I'll delete it eventually.




# # TODO:
# # - test the distance requirements for all three curves
# # - Using 3 curves is broken when the rise is faster than the fall
# # rise, fall, er
# # slow, fast, fast [x]
# # slow, fast, slow [x]
# # fast, slow, fast [ ] doesn't meet max height
# # fast, slow, slow [ ] releasing the button at different states makes the player fall slower or faster

# tool
# ## Remember to multiply gravities by -1
# extends Jumping


# # Coyote time variables.
# var coyote_time := 0.1
# var can_coyote_jump := true

# # Player's current velocity.
# var velocity := Vector2.ZERO setget set_velocity, get_velocity

# var jump_buffer := 0.016 # Roughly one frame

# var did_feather_jump = false





# func _ready():
	# print("Ready printing curves...")
	# for i in curves_arr:
		# print("%s\n\n" % i)
	# print("printing done")


# var previous_velocity := Vector2.ZERO

# func _physics_process(delta):
	# # Code to execute when in game.
	# if not Engine.editor_hint:
		# # Movement is shown on screen.
		# # move_and_slide reverts our velocity to 0 on the floor
		# velocity = move_and_slide(velocity, Vector2.UP)
		
		
		
		# # Gravity is applied to velocity.
		# velocity = apply_gravity( velocity, delta )
		
		
		
# #		# Disable coyote jumping while on the floor.
# #		if is_on_floor():
# #			can_coyote_jump = false
# #
		
# #
# ##		if player_fall_state == falling_states.EARLY_FALLING:
# ##			velocity.y = 0
# #
# #
# #		# Kills upward velocity when the jump button is let go
# #		if (previous_fall_state == falling_states.NOT_FALLING) && (player_fall_state == falling_states.EARLY_FALLING):
# #			velocity.y = 1
# #
# #		# When falling w/o jumping (ex: sliping off an edge) call coyote_time.
# #		# Try remaking this with your fall states.
# #		if (velocity.y > 0) && (previous_velocity.y == 0):
# #			enable_coyote_time()
# #
# #

# #
# #		# Current velocity is set as the previous velocity.
# #		if (previous_velocity != velocity):
# #			print("velocity: %s" % velocity)
# #			print("Falling state: %s\n" % get_player_fall_state_str() )
# #			previous_velocity = velocity


# func _unhandled_key_input(_event):
	# # Code to execute when in game.
	# if not Engine.editor_hint:
		# process_input()
		# if Input.is_action_just_pressed("jump"):
			# if is_on_floor():
				# # Jump from a standstill
				# print("Debug: Jump from a standstill")
				# jump()
# #			elif can_coyote_jump:
# #				# Jump after leaving a ledge
# #				print("Debug: Jump after leaving a ledge")
# #				jump()
# #			else:
# #				# Jump pressed right before hitting the floor
# #				print("Debug: Jump pressed right before hitting the floor")
# #				call_jump_buffered()


# # Save the jump input and later check if the input would of been valid.
# func call_jump_buffered():
	# yield(get_tree().create_timer(jump_buffer), "timeout")
	# if is_on_floor():
		# jump()


# # Enables can_coyote_jump briefly
# func enable_coyote_time():
	# can_coyote_jump = true
	# yield(get_tree().create_timer(coyote_time), "timeout")
	# can_coyote_jump = false


# func jump():
	# print("Debug: Inital Velocity applied")
	# if (curves_used_in_graph == 1):
		# velocity.y = ( -1 * get_curve(curve_types.BASE).get_inital_velocity() )
	# else:
		# velocity.y = ( -1 * get_curve(curve_types.RISE).get_inital_velocity() )





# # New player inputs are processed. 
# # Lateral Movement
# # Needs move_and_slide in _physics_process
# func process_input():
	# var dir = 0
	# if Input.is_action_pressed("move_right"):
		# dir += 1
	# if Input.is_action_pressed("move_left"):
		# dir -= 1
	# if dir != 0:
		# velocity.x = dir * max_lateral_speed #lerp(velocity.x, dir * max_lateral_speed, acceleration)
	# else:
		# velocity.x = dir #lerp(velocity.x, 0, friction)
	# return dir




# # Setters / Getters
# func set_velocity(value:Vector2) -> void:
	# velocity = value

# func get_velocity() -> Vector2:
	# return velocity

