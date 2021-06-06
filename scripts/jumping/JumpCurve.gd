# Different types of curves.
# BASE - A true to life physics projectile curve
# RISE - The rising trajectory of a jump; The left half of the curve is used
# FALL - The falling trajectory of a jump; The right half of the curve is used
# EARLY_RELEASE - The lightly tapped jump trajectory; For variable hight

# Lemme Explain:
# - I'm using this to make a piece of a curve.
# - It's to hold and calculate all the variables we will need for our jump.
# - Did some analyzing and noticed some stuff.
# - Basicaly curves will share certain properties (ex. the same max_x_velocity)
# - The conditions in _get_property_list refect this.
# - Yuh that was it.

# Don't forget to consider:
# - gravity has been multiplied by -1 for direction
# - There will be some error proportional to how fast/large 
#   the inital velocity turns out to be.

extends Node
class_name JumpCurve




# It's an enumerated value see top for full list of curves.
var curve_type := 0        setget         set_curve_type, get_curve_type

# Critical variables.
# Must be defined by user to calculate the rest.
var y_distance_to_peak:int setget set_y_distance_to_peak, get_y_distance_to_peak # (h)
var max_x_distance    :int setget     set_max_x_distance, get_max_x_distance # (m)
var max_x_velocity    :int setget     set_max_x_velocity, get_max_x_velocity # (Vx)

# Defined w/ the calculate functions.
var x_distance_to_peak:float setget set_x_distance_to_peak, get_x_distance_to_peak # (Xh)
var inital_velocity:float    setget    set_inital_velocity, get_inital_velocity # (V0)
var gravity: float           setget            set_gravity, get_gravity # (g)

# Allows for printing in the console (mostly for debugging).
var allow_printing_initalization := false setget set_allow_printing_initalization, is_printing_initalization_allowed
var allow_printing_calculations  := false setget  set_allow_printing_calculations, is_printing_calculations_allowed




# Sets the critical variables and calculates the rest.
func initalize_variables( acurve_type:int= 0, height:int= 69, distance:int= 69, max_velocity:int= 69 ) -> void:
	# Acknowledge that we are in the process of defining the curve.
	if (allow_printing_initalization):
		print("\n\nInitalization in process...")

	# Critical variables set.
	set_curve_type(acurve_type)
	set_y_distance_to_peak(height)
	set_max_x_distance(distance)
	set_max_x_velocity(max_velocity)

	# Calculating the rest.
	calculate_all_three()

	# Acknowledge that we are done defining the curve.
	if (allow_printing_initalization):
		print("Initalization Complete [x]\n\n%s" % self._to_string() )


# Calculates: 
# - x_distance_to_peak
# - inital_velocity
# - gravity
func calculate_all_three( ) -> void:
	# Acknowledge that we are in the process of calculating.
	if (allow_printing_initalization):
		print("\nBegining calculations...")

	calculate_x_distance_to_peak()
	calculate_inital_velocity()
	calculate_gravity()

	# Acknowledge that we are done calculating.
	if (allow_printing_initalization):
		print("Calculations Complete [x]")


# Calculate functions have three sections.
# - "What we used" is all the critical variables.
# - "Our answer" is the answer.
# - "Printing" prints the two sections above

# Formula: v = √( V0^2 + 2gy )
func calculate_current_y_velocity(cur_y: float) -> float:
	# What we used.
	var V0 := get_inital_velocity()
	var g := get_gravity()

	# Our answer.
	return sqrt( pow(V0,2) + (2 * g * cur_y) )


# Formula: m / 2
func calculate_x_distance_to_peak() -> void:
	# What we used.
	var m := get_max_x_distance()

	# Our answer.
	set_x_distance_to_peak( m / 2 )

	# Printing.
	if (allow_printing_calculations):
		var msg := "Calculating x_distance_to_peak...\n"
		msg += "Got [max_x_distance]: %d\n"
		msg += "Setting x_distance_to_peak = %f\n"
		print(msg % [m, get_x_distance_to_peak() ] )


# Calculates the y-velocity that will meet the max_x_distance & 
# y_distance_to_peak constraints.
# Actually did some testing and 
# the larger this has to be the more inaccurate. I haven't bashed 
# my head heard enough but it's starting to hurt. Future me fix it! (if you can)
# Formula: (2 * h * Vx) / Xh
func calculate_inital_velocity() -> void:
	# What we used.
	var h  := get_y_distance_to_peak()
	var Vx := get_max_x_velocity()
	var Xh := get_x_distance_to_peak()

	# Our answer.
	# Multiplying -1 for direction.
	set_inital_velocity( (2 * h * Vx) / (Xh) * -1)

	# Printing.
	if (allow_printing_calculations):
		var msg := "Calculating inital_velocity...\n"
		msg += "Got [y_distance_to_peak]: %d\n"
		msg += "Got [max_x_velocity]: %d\n"
		msg += "Got [get_x_distance_to_peak]: %f\n"
		msg += "Setting inital_velocity: %f\n"
		print(msg % [h, Vx, Xh, get_inital_velocity() ] )


# Calculates this curve's gravity.
# Formula: (-2 * h * Vx^2) / Xh^2
func calculate_gravity() -> void:
	# What we used.
	var h  := get_y_distance_to_peak()
	var Xh := get_x_distance_to_peak()
	var Vx := get_max_x_velocity()

	# Our answer.
	# Multiplying -1 for direction.
	set_gravity( (-2 * h * pow(Vx, 2) ) / (pow(Xh, 2)) * -1 )

	# Printing.
	if (allow_printing_calculations):
		var msg := "Calculating calculate_gravity...\n"
		msg += "Got [y_distance_to_peak]: %d\n"
		msg += "Got [x_distance_to_peak]: %f\n"
		msg += "Got [max_x_velocity]: %d\n"
		msg += "Setting gravity to: %f\n"
		print(msg % [ h, Xh, Vx, get_gravity() ] )


# Getting the curve name
func get_curve_name() -> String:
	match get_curve_type():
		0:
			return "BASE"
		1:
			return "RISE"
		2:
			return"FALL"
		3:
			return "EARLY_RELEASE"
		_:
			return "No Curve Identified... wtheck"


# Returns the information of the curve.
func _to_string()-> String:
	var msg = "// Jump Curve Properties \\\\"
	msg += "\ncurve type:  %s" % get_curve_name()
	msg += "\nmax height:  %d px" % get_y_distance_to_peak()
	msg += "\nmax distance (how far): %d px" % get_max_x_distance()
	msg += "\nx_distance_to_peak (half of how far): %f px" % get_x_distance_to_peak()
	msg += "\nmax x speed: %d px/sec" % get_max_x_velocity()
	msg += "\ninital_velocity (when jumping): %f px/sec" % get_inital_velocity()
	msg += "\ngravity: %f px/sec^2" % get_gravity()
	return msg




# Setters & Getters.
func set_curve_type( value:int ) -> void:
	curve_type = value

func get_curve_type() -> int:
	return curve_type


func set_y_distance_to_peak( value:int ) -> void:
	y_distance_to_peak = value

func get_y_distance_to_peak() -> int:
	return y_distance_to_peak


func set_max_x_distance( value:int ) -> void:
	max_x_distance = value

func get_max_x_distance() -> int:
	return max_x_distance


func set_max_x_velocity( value:int ) -> void:
	max_x_velocity = value

func get_max_x_velocity() -> int:
	return max_x_velocity


func set_x_distance_to_peak( value:float ) -> void:
	x_distance_to_peak = value

func get_x_distance_to_peak() -> float:
	return x_distance_to_peak


func set_inital_velocity( value:float ) -> void:
	inital_velocity = value

func get_inital_velocity() -> float:
	return inital_velocity


func set_gravity( value:float ) -> void:
	gravity = value

func get_gravity() -> float:
	return gravity


func set_allow_printing_initalization( value:bool ) -> void:
	allow_printing_initalization = value

func is_printing_initalization_allowed() -> bool:
	return allow_printing_initalization


func set_allow_printing_calculations( value:bool ) -> void:
	allow_printing_calculations = value

func is_printing_calculations_allowed() -> bool:
	return allow_printing_calculations

