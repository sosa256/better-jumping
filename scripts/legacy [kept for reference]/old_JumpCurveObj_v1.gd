## Different types of curves.
## BASE - A true to life physics projectile curve
## RISE - The rising trajectory of a jump; The left half of the curve is used
## FALL - The falling trajectory of a jump; The right half of the curve is used
## EARLY_RELEASE - The lightly tapped jump trajectory; For variable hight
##enum curve_types {}
#tool
#extends Resource
#class_name JumpCurve
#
#
#var curve_type := 0 setget set_curve_type, get_curve_type
#
## Must be defined first to get the curve info
#var y_distance_to_peak := 10 setget set_y_distance_to_peak, get_y_distance_to_peak # (h)
#var max_x_distance     := 10 setget     set_max_x_distance, get_max_x_distance # (m)
#var max_x_velocity     := 10 setget     set_max_x_velocity, get_max_x_velocity # (Vx)
#
## Initalize w/ the calculate functions
#var x_distance_to_peak:float setget set_x_distance_to_peak, get_x_distance_to_peak # (Xh)
#var inital_velocity:float    setget    set_inital_velocity, get_inital_velocity # (V0)
#var gravity: float           setget            set_gravity, get_gravity # (g)
#
## Allows for printing in the console
#var allow_printing_initalization := false setget set_allow_printing_initalization, get_allow_printing_initalization
#var allow_printing_calculations  := false setget set_allow_printing_calculations, get_allow_printing_calculations
#
## Properties to show in the editor
#var exposed_properties := {
#	"Curve Type": get_curve_type(),
#	"Jump Curve/Max Height": get_y_distance_to_peak(),
#	"Jump Curve/Max Distance": get_max_x_distance(),
#	"Jump Curve/Max Lateral Speed": get_max_x_velocity(),
#	"Printing Curve/Print Initalization": get_allow_printing_initalization(),
#	"Printing Curve/Print Calculations": get_allow_printing_calculations(),
#}
#
#
#
#
## Calculate functions
## Formula: m / 2
#func calculate_x_distance_to_peak() -> void:
#	var m = get_max_x_distance()
#	if (allow_printing_calculations):
#		print("Calculating x_distance_to_peak...\nGot [max_x_distance]: %d\nSetting x_distance_to_peak = %f" % [m, (m/2) ] )
#	set_x_distance_to_peak( m / 2 )
#
#
## Formula: (2 * h * Vx) / Xh
#func calculate_inital_velocity() -> void:
#	var h = get_y_distance_to_peak()
#	var Vx = get_max_x_velocity()
#	var Xh = get_x_distance_to_peak()
#	if (allow_printing_calculations):
#		print("Calculating inital_velocity...\nGot [y_distance_to_peak]: %d\nGot [max_x_velocity]: %d\nGot [get_x_distance_to_peak]: %f\nSetting x_distance_to_peak = %f" % [h, Vx, Xh, ( (2 * h * Vx) / (Xh) ) ] )
#	set_inital_velocity( (2 * h * Vx) / (Xh) )
#
#
## Formula: (-2 * h * Vx^2) / Xh^2
#func calculate_gravity() -> void:
#	var h = get_y_distance_to_peak()
#	var Xh = get_x_distance_to_peak()
#	var Vx = get_max_x_velocity()
#	if (allow_printing_calculations):
#		print("Calculating calculate_gravity...\nGot [y_distance_to_peak]: %d\nGot [x_distance_to_peak]: %f\nGot [max_x_velocity]: %d\nSetting x_distance_to_peak = %f" % [h, Xh, Vx, ( (-2 * h * pow(Vx, 2) ) / (pow(Xh, 2)) ) ] )
#	set_gravity( (-2 * h * pow(Vx, 2) ) / (pow(Xh, 2)) )
#
#
#func _to_string()-> String:
#	var msg = "//JumpCurve Properties\\\\"
##	msg += "\nName: %s" % resource_name
#	msg += "\nCurve Type: %d" % get_curve_type()
#	msg += "\ny_distance_to_peak (max height): %d px" % get_y_distance_to_peak()
#	msg += "\nmax_x_distance (of jump): %d px" % get_max_x_distance()
#	msg += "\nmax_x_velocity: %d px/sec" % get_max_x_velocity()
#	msg += "\nx_distance_to_peak: %f px" % get_x_distance_to_peak()
#	msg += "\ninital_velocity: %f px/sec" % get_inital_velocity()
#	msg += "\ngravity: %f px/sec^2" % get_gravity()
#	return msg
#
#
#func initalize_variables( acurve_type:int, h:int, d:int, vx:int ) -> void:
#	if (allow_printing_initalization):
#		print("\n\nInitalization in process...")
#	set_curve_type(acurve_type)
#	set_y_distance_to_peak(h)
#	set_max_x_distance(d)
#	set_max_x_velocity(vx)
#	if (allow_printing_initalization):
#		print("\nBegining calculations...")
#	calculate_x_distance_to_peak()
#	calculate_inital_velocity()
#	calculate_gravity()
#	if (allow_printing_initalization):
#		print("Calculations Complete [x]")
#		print("Initalization Complete [x]\n\n%s" % self._to_string() )
#
#
## Self-explanitory and already impemented.
## Just add new propertes here also.
#func update_variables() -> void:
#	set_curve_type( exposed_properties["Curve Type"] )
#	set_y_distance_to_peak( exposed_properties["Jump Curve/Max Height"] )
#	set_max_x_distance( exposed_properties["Jump Curve/Max Distance"] )
#	set_max_x_velocity( exposed_properties["Jump Curve/Max Lateral Speed"] )
#	set_allow_printing_initalization( exposed_properties["Printing Curve/Print Initalization"] )
#	set_allow_printing_calculations( exposed_properties["Printing Curve/Print Calculations"] )
#	initalize_variables( get_curve_type(), get_y_distance_to_peak(), get_max_x_distance(), get_max_x_velocity() )
#
#
#
#
## Property List
## You're gonna have to do this by hand.
## The conditions for when properties appear are set here.
## Conditions for the properties must using the dictionary.
## The order here is how the properties will also be ordered.y
#func _get_property_list() -> Array:
#	var property_arr := []
#
#	property_arr.append({
#		"name": "Curve Type",
#		"type": TYPE_INT,
#		"hint": PROPERTY_HINT_ENUM,
#		"hint_string": "BASE, RISE, FALL, EARLY_RELEASE"
#	})
#
#	property_arr.append({
#		"name": "Jump Curve/Max Height",
#		"type": TYPE_INT,
#	})
#
#	property_arr.append({
#		"name": "Jump Curve/Max Distance",
#		"type": TYPE_INT,
#	})
#
#	property_arr.append({
#		"name": "Jump Curve/Max Lateral Speed",
#		"type": TYPE_INT,
#	})
#
#	property_arr.append({
#		"name": "Printing Curve/Print Initalization",
#		"type": TYPE_BOOL,
#	})
#
#	if (exposed_properties["Printing Curve/Print Initalization"]):
#		property_arr.append({
#			"name": "Printing Curve/Print Calculations",
#			"type": TYPE_BOOL,
#		})
#	else:
#		# The value here should match up with the defaults
#		exposed_properties["Printing Curve/Print Calculations"] = false
#
#
#	return property_arr
#
#
## To update property list have an if statement that checks all the conditional properties
#func _set(prop_name: String, val) -> bool:
#	var property_exists: bool = false
#
#	for i in exposed_properties.keys():
#		if (i == prop_name):
#			property_exists = true
#			exposed_properties[prop_name] = val
#			update_variables()
#			if( (prop_name == "Printing Curve/Print Initalization") ):
#				property_list_changed_notify()
#
#	return property_exists
#
#
## Get property
#func _get(prop_name: String):
#	for i in exposed_properties.keys():
#		if (i == prop_name):
#			return exposed_properties[prop_name]
#
#	return null
#
#
#
#
## Setters / Getters
#func set_curve_type( value:int ) -> void:
#	curve_type = value
#
#func get_curve_type() -> int:
#	return curve_type
#
#
#func set_y_distance_to_peak( value:int ) -> void:
#	y_distance_to_peak = value
#
#func get_y_distance_to_peak() -> int:
#	return y_distance_to_peak
#
#
#func set_max_x_distance( value:int ) -> void:
#	max_x_distance = value
#
#func get_max_x_distance() -> int:
#	return max_x_distance
#
#
#func set_max_x_velocity( value:int ) -> void:
#	max_x_velocity = value
#
#func get_max_x_velocity() -> int:
#	return max_x_velocity
#
#
#func set_x_distance_to_peak( value:float ) -> void:
#	x_distance_to_peak = value
#
#func get_x_distance_to_peak() -> float:
#	return x_distance_to_peak
#
#
#func set_inital_velocity( value:float ) -> void:
#	inital_velocity = value
#
#func get_inital_velocity() -> float:
#	return inital_velocity
#
#
#func set_gravity( value:float ) -> void:
#	gravity = value
#
#func get_gravity() -> float:
#	return gravity
#
#
#func set_allow_printing_initalization( value:bool ) -> void:
#	allow_printing_initalization = value
#
#func get_allow_printing_initalization() -> bool:
#	return allow_printing_initalization
#
#
#func set_allow_printing_calculations( value:bool ) -> void:
#	allow_printing_calculations = value
#
#func get_allow_printing_calculations() -> bool:
#	return allow_printing_calculations
#
#
