## DESCRIPTION
# Remember gravities and inital velocities have been multiplied by -1 already.
#
# Your mileage may vary with the maxed height and distance.
# Copied from JumpCurve.gd
# "Actually did some testing and 
# the larger this [inital velocity] has to be the more inaccurate. I haven't bashed 
# my head heard enough but it's starting to hurt. Future me fix it! (if you can)"
# 
# Basically "There will be some error proportional to how fast/large 
# the inital velocity turns out to be."

tool
extends Jumping_TTL




## DATA
# Player's current velocity.
var velocity := Vector2.ZERO setget set_velocity, get_velocity

# Get coyote time script from Node.
onready var ct = get_node("CoyoteTime")

# Buffer time in ms.
var jump_buffer := 0.016 # Roughly one frame

# For finding actual max height and distance.
var max_hight_dist := HeightDistMidjump.new()




## FUNCTIONS
# Main loop.
func _physics_process(delta):
	# Code to execute when in game.
	if not Engine.editor_hint:
		# Disable coyote jumping while on the floor.
		ct.coyote_is_on_floor( is_on_floor() )
		
		# Movement is shown on screen.
		# move_and_slide reverts our velocity to 0 on the floor.
		velocity = move_and_slide(velocity, Vector2.UP)
		
		# Updates our current height and distance in a jump.
		max_hight_dist.update(global_position, is_on_floor())
		
		# This motherfucker...
		# Placed here b/c gravity affects the vel.y so it can't 0 (zero).
		# Thus affecting certain detection mechanisms in coyote time.
		ct.coyote_wo_falling(velocity.y)
		
		# Gravity is applied to velocity.
		velocity = apply_gravity( velocity, delta )


# New player inputs are processed. 
# Old movement properties.
	# var friction = 0.1
	# var acceleration = 0.25
# Lateral Movement
# Needs move_and_slide in _physics_process to display actions.
func process_lateral_input() -> int:
	var dir = 0
	if Input.is_action_pressed("move_right"):
		dir += 1
	if Input.is_action_pressed("move_left"):
		dir -= 1
	if dir != 0:
		velocity.x = dir * max_lateral_speed #lerp(velocity.x, dir * max_lateral_speed, acceleration)
	else:
		velocity.x = dir #lerp(velocity.x, 0, friction)
	return dir


# Saves the jump input and later check if the input would of been valid.
func call_jump_buffered():
	yield(get_tree().create_timer(jump_buffer), "timeout")
	if is_on_floor():
#		print("Debug: Jump pressed right before hitting the floor")
		velocity = jump(velocity)


func process_vertical_input():
	if Input.is_action_just_pressed("jump"):
#		print("Debug: Jump pressed")
		if is_on_floor():
			# Jump from a standstill
#			print("Debug: Jump from a standstill")
			velocity = jump(velocity)
		elif ct.can_coyote_jump:
			# Jump after leaving a ledge
#				print("Debug: Jump after leaving a ledge")
			velocity = jump(velocity)
		else:
			# Jump pressed right before hitting the floor
			call_jump_buffered()


func _unhandled_key_input(_event):
	# Code to execute when in game.
	if not Engine.editor_hint:
		process_lateral_input()
		process_vertical_input()




## SET / GET FUNCTIONS
func set_velocity(value:Vector2) -> void:
	velocity = value

func get_velocity() -> Vector2:
	return velocity

