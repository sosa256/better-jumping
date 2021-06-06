### KEPT for legacy reasons
## This code was made by me :^) (GV2)
## However it was heavily inspired from the "Building a Better Jump" GDC talk.
## Here's da link for that: https://www.youtube.com/watch?v=hG9SzQxaCm8
#extends KinematicBody2D
#
#var max_jump_height = 64 # Units in pixels.
#var max_x_velocity = 48 # Units pixels/second.
## This is kept for making the jump graphs
## var max_jump_distance = 160
#
#var gravity = -1 * calculate_gravity(max_jump_height, max_x_velocity , 120)
#var fall_gravity = -1 * calculate_gravity(max_jump_height, max_x_velocity , 40)
#var inital_jump_velocity = -1 * calculate_inital_jump_velocity(max_jump_height, max_x_velocity, 120)
#
## TODO: find a way to calculate these factors later
#var friction = 0.1
#var acceleration = 0.25
#
##Player velocity.
#var velocity = Vector2.ZERO
#
#
#
#func _ready():
#	print("jump gravity: %s pixels/sec^2" % gravity)
#	print("fall gravity: %s pixels/sec^2" % fall_gravity)
#	print("inital jump velocity: %s pixels/sec" % inital_jump_velocity)
#
#func _physics_process(delta):
#	velocity.y += gravity * delta
#	velocity = move_and_slide(velocity, Vector2.UP)
#	process_input()
#	if Input.is_action_just_pressed("jump"):
#		if is_on_floor():
#			velocity.y = inital_jump_velocity
## These if statements handle variable jumping
## When falling, gravity is increased to fall faster.
#	if velocity.y > 0:
#		velocity.y += fall_gravity * delta
## When jumping and the "jump" button is let go before the peak, gravity is increased
#	elif velocity.y < 0 && not Input.is_action_pressed("jump"):
#		velocity.y += fall_gravity * delta
## For debugging, comment out later.
##	if last_velocity_y != velocity.y  || last_velocity_x != velocity.x:
##		print("player velocity: (%.3f, %.3f)" % [velocity.x, velocity.y] )
##	last_velocity_y = velocity.y
##	last_velocity_x = velocity.x
#
#
#
## The formula to calculate gravity is derived from this ideal jump trajectory in terms of
## distance and how fast our character moves from side to side: 
## f(x) = (0.5 * g * x^2) + (v0 * x) +p0
## Where  g is gravity, 
##       v0 is initial jump velocity, 
##       p0 is initial y position of the character (assumed to be 0),
##     f(x) is the height of jump, and
##        x is distance in the x direction
## make sure you have graphed your character's jump before using these functions
##
## Generally the "max_height" and "max_x_velocity" parameters will 
## remain the same for diferent parts of the jump curve.
## "x_distance_to_peak" will change depending on how you change 
## parts of your curve.
#func calculate_gravity(max_height, max_x_velocity, x_distance_to_peak):
#	var g = (-2 * max_height * pow(max_x_velocity,2)) / (pow(x_distance_to_peak,2))
#	return g
#
#func calculate_inital_jump_velocity(max_height, max_x_velocity, x_distance_to_peak):
#	var v = (2 * max_height * max_x_velocity) / x_distance_to_peak
#	return v
#
#func process_input():
#	var dir = 0
#	if Input.is_action_pressed("move_right"):
#		dir += 1
#	if Input.is_action_pressed("move_left"):
#		dir -= 1
#	if dir != 0:
#		velocity.x = lerp(velocity.x, dir * max_x_velocity, acceleration)
#	else:
#		velocity.x = lerp(velocity.x, 0, friction)
