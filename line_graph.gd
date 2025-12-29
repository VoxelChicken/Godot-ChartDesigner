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
	
	var x_increment = x_size / (total_point_count - 1)
	
	var vector2_array: PackedVector2Array
	vector2_array.resize(total_point_count)
	
	for i in total_point_count:
		helper_var += x_increment * i
		vector2_array[i].x = helper_var
