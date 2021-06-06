# Variable Jump (2 curves)
## DESCRIPTION
# Is an extension of RF.gd.
#
# Graph: https://www.desmos.com/calculator/ngsa4tpciw
# Look in RF.gd for instructions.
#
# The player can stop mid-rise of a jump.

tool
extends Jumping_RF
class_name Jumping_VJ




## DATA
# Units are in pixles.
export var min_jump_height := 69 setget set_min_jump_height, get_min_jump_height
var valid_min_release := false

var max_hight_dist := HeightDistMidjump.new()




## FUNCTIONS
# Will stop the player jump now or in the future when 'jump' is released.
# Only to be called when 'jump' was just released.
# We assume the driver has already checked for a just released 'jump'.
func variable_jump(p_vel:Vector2)-> Vector2:
	if curr_fall_state != falling_states.RISING:
		# Player released 'jump' while falling or standing.
		# We are already falling there is nothing more to do.
		# We standing probably after the jump.
		return p_vel
	
	# The falling state is stand or rise.
	if (max_hight_dist.get_height() < min_jump_height):
		# Player released 'jump' under the minimum height.
		# We will travel to min height first 
		# and then stop the jump.
		# Handled in check_min_jump().
		valid_min_release = true
		return p_vel
	
	# Player released 'jump' somewhere past the minimum height.
	# Jump velocity is 1 to avoid activating coyote time
	# since coyote time is dependant on Jump velocity.
	p_vel.y = 1
	return p_vel


# Checks when we are ready to stop the jump if need be.
func check_min_jump(p_vel:Vector2) -> Vector2:
	if not valid_min_release:
		# We were not givin the ok of a released 'jump' before minimum height.
		return p_vel

	# 'jump' was released before minimum height.
	if (max_hight_dist.get_height() < min_jump_height):
		# We still need to travel to the minimum height.
		return p_vel

	# We have at least reached the minimum height.
	valid_min_release = false # reset the ok.
	p_vel.y = 1               # If it was zero coyote time would activate.
	return p_vel




## SET / GET FUNCTIONS
func set_min_jump_height(value:int) -> void:
	min_jump_height = value

func get_min_jump_height() -> int:
	return min_jump_height




## EDITOR FUNCTIONS
# There are none.
# I could not figure out how to properly override the editor functions to 
# include the minimum jump height. When I tried it would show duplicates and
# minimum jump height for a total of 9 elements. I don't know enough to figure  
# it out so I used Occam's razor and just exported the variable. It works well
# enough.
