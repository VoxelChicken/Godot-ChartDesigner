@icon("res://LineGraph2D.png")

## The [code] LineGraph2D [/code] is the Add-on alternative to writing your own line graph. It makes making a line graph simple and easy. To set up the size of the [code] LineGraph2D [/code], you just have resize the control node in the editor.
## Follow up with a glance at the inspector - it has the variables required for building the line graph, and most importantly, it has the [code] PackedVector2Array [/code] for the points.
## The variables, apart from the [code] PackedFloat64Array [/code], include Color, Width, and Anti-aliasing. Tune these to your preference and you have yourself an easy line graph, enjoy![br][br]
## (Note: This is an open-source passion project by a solo developer. Updates are most likely not going to appear at regular intervals, but rather, at random.)
class_name LineGraph2D
extends Control

## The 'values' [code] array [/code] is the array for the values displayed on the [code] y axis [/code] in the LineGraph2D. It is also exported to the inspector on the right side of the screen (default setting).
@export var values: PackedFloat64Array
## This variable is simply exported to the inspector, where you can choose which color you want the [code] LineGraph2D [/code] to have.
@export var color: Color
## This variable is also exported to the editor. This is the width of the [code] LineGraph2D [/code]. Setting it to -1 makes the line as thin as possible, in some cases, even less than 1 pixel wide.
@export var width: float
## This is the antialiasing [code] bool [/code]. It's also exported to the inspector. The antialiasing makes the pixelated lines smooth if '[code] True [/code]' ('On').
@export var antialiasing: bool
## This [code] bool [/code] makes the [code] LineGraph2D [/code] adaptable to the values. e.g.: if you have something that is more than a 0 as a minimum value, the graph adapts to the minimum variable, so that the bottom part of the LineGraph2D isn't the "zero line", but rather the minimum variable itself.
@export var value_adapting: bool

## This method ([code]set_values[/code]) replaces the current values with new ones. It can be called when a function is pressed, like:
## 
## [codeblock]
## func _on_button_pressed() -> void:
## 	set_values([4, 2, 5, 1])
## [/codeblock]
func set_values(new_values: PackedFloat64Array) -> void:
	values = new_values
	queue_redraw()
  
func _init() -> void:
	resized.connect(queue_redraw)

func _draw() -> void:
	var total_point_count := float(len(values))
	var x_size := get_rect().size.x
	var y_size := get_rect().size.y
	var min: float # 'Min' is short for 'minimum' and is the smallest amount in the 'values' array.
	var max: float # 'Max' is short for 'maximum' and is the largest amount in the 'values' array.
	
	var x_increment = x_size / (total_point_count - 1)
	
	var vector2_array: PackedVector2Array
	vector2_array.resize(total_point_count)
	
	min = values[0] # This is for the iteration of the array to work well. This makes the 'smallest_value' NOT be 0.
	for value in values:
		if value > max:
			max = value
		if value < min:
			min = value
		# The for loop above cycles through the array 'values' and assigns 'min' and 'max' accordingly. (Declaration of the variables in the code above)
	
	if value_adapting == false:
		for i in total_point_count:
			vector2_array[i] = Vector2(
				x_increment * i, # x value
				y_size - (y_size / max * values[i]) # y value
				)
	else:
		print("Not developed yet, sorry!")
	
	print("Maximum:")
	print(max)
	print("Minimum:")
	print(min)
	print("PackedVector2Array:")
	print(vector2_array)

	draw_polyline(vector2_array, color, width, antialiasing) 
