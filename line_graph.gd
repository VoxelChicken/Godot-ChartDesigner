class_name LineGraph
extends Control

@export var values: PackedFloat64Array

func set_values(new_values: PackedFloat64Array) -> void:
	values = new_values
	queue_redraw()

func _init() -> void:
	resized.connect(queue_redraw)

func _draw() -> void:
	var total_point_count := float(len(values))
	var x_size := get_rect().size.x
	var y_size := get_rect().size.y
	var helper_var: int
	var smallest_value: float
	var biggest_value: float
	
	var x_increment = x_size / (total_point_count - 1)
	
	var vector2_array: PackedVector2Array
	vector2_array.resize(total_point_count)
	
	for i in total_point_count:
		helper_var += x_increment * i
		vector2_array[i].x = helper_var
	
	smallest_value = values[0] # This is for the iteration of the array to work well. This makes the 'smallest_value' NOT be 0.
	for value in values:
		if value > biggest_value:
			biggest_value = value
		if value < smallest_value:
			smallest_value = value
		
	print("max:")
	print(biggest_value)
	print("min:")
	print(smallest_value)
