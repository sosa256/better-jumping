### Distance Height Tracker for 2D Platforming
## DESCRIPTION
# Tracks player's height and distance relative to last jump.

extends Node
class_name HeightDistMidjump

## DATA
# Player's last grounded position after jump.
var origin := Vector2.ZERO
# Player position relative to the origin.
var p_point :=Vector2.ZERO

var max_height := 0 setget , get_max_height
var max_distance := 0 setget , get_max_distance




## FUNCTIONS
# Finds out how high (height) and far (distance) we are in a jump.
# Also updates new maximums if needed.
func update(p_pos:Vector2, is_on_floor:bool):
	if is_on_floor:
		# Define our new origin.
		origin = p_pos
	else:
		# Calculate our point from the origin.
		p_point = Vector2( abs(origin.x - p_pos.x), abs(origin.y - p_pos.y))
		max_height = max( get_height(), max_height)
		max_distance = max( get_distance(), max_distance)




## GET FUNCTIONS
# Rename these to get_curr for clarity
func get_height() -> float:
	return p_point.y

func get_distance() -> float:
	return p_point.x

func get_max_height() -> int:
	return max_height

func get_max_distance() -> int:
	return max_distance
