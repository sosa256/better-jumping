## DESCRIPTION
# Displays player's current velocity component and
# player's max height and distance.

extends Node




## DATA
# Player reference.
export (NodePath) var player_node_path
onready var player:KinematicBody2D = get_node(player_node_path)

# Lable reference.
export (NodePath) var label_node_path
onready var debug_label:Label = get_node(label_node_path)

# String formats for the debug_label.
var maxes = "Max height: %f\nMax distance: %f\n"
var velocity = "Velocity\nx:%3d\ny:%3d\n\n"




## FUNCTIONS
# Main loop.
func _process(_delta):
	# Write the current maximums.
	# If there's an error here that means the lable NodePath was probably null.
	# Fix it by going to the scene's root node and adding the paths (in Script Variables) 
	# from the editor. 
	debug_label.text = maxes % [player.max_hight_dist.get_max_height(), player.max_hight_dist.get_max_distance()]
	
	# Write the current player velocity.
	# Multiply vel.y by -1 so I understand it intuitively (up is now positive).
	debug_label.text += velocity % [player.velocity.x, player.velocity.y * -1]
	
	# Let's me quit faster than clicking the x.
	if Input.is_action_pressed("quit"):
		get_tree().quit()

