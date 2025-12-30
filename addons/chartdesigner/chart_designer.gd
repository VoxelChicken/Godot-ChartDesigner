@icon("res://addons/chartdesigner/LineGraph2D.png")

## The ChartDesigner is the Add-on alternative to writing your own charts. It makes making charts simple and easy. To set up the size of the desired chart, you just have to set up the control node to the desired size of the chart.
## Follow up with a glance at the inspector - it has the variables required for designing the desired chart, and most importantly, it contains the [code]PackedFloat64Array[/code] for the points
## (in the inspector, the 'values' array isn't a [code]PackedVector2Array[/code], which the Godot's [code]Line2D[/code] uses, but rather a [code]PackedFloat64Array[/code]. This is because the only thing the user has to do is give the graph the values, because the regular increments on the x axis are done automatically calculated).
## The variables, apart from the [code]PackedFloat64Array[/code], include Color, Width, and Anti-aliasing. Tune these to your preference and you have yourself an easy chart, enjoy![br][br]
## (Note: This is an open-source passion project by a solo developer. Updates are most likely not going to appear at regular intervals, but rather, at random.)
class_name ChartDesigner
extends Control

enum ChartType{
	LineChart,
	BarChartVertical,
	BarChartHorizontal,
}

## This exported enum gives you a drop-down menu containing different chart types.
@export var type: ChartType


## This  group holds the settings for the Line- and BarChart.
@export_group("LineChart & BarChart")

## The 'values' array is the array for the values displayed on the y axis in the chart. It is also exported to the inspector on the right side of the screen (default setting).
@export var values: PackedFloat64Array

## With this color, you can choose which color you want the line to have.
@export var line_color: Color
## With this color you can choose your desired width of the x and y line's width. Setting it to -1 makes the line as thin as possible, in some cases, even less than 1 pixel wide.
@export var x_y_lines_color: Color

## With this color you can choose your desired width of the line width. Setting it to -1 makes the line as thin as possible, in some cases, even less than 1 pixel wide.
@export var line_width: float
## This variable is the width of the background lines that indicate the x and y axes.
@export var x_y_lines_width: float

## This is the antialiasing [code] bool [/code]. It's also exported to the inspector. The antialiasing makes the pixelated lines smooth if '[code] True [/code]' ('On').
@export var antialiasing: bool

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
	var total_point_count := len(values)
	
	var x_size := get_rect().size.x
	var y_size := get_rect().size.y
	
	var min_val: float # 'Min' is short for 'minimum value' and is the smallest value in the 'values' array.
	var min_val_index: int # The index of the min_val in the 'values' array.
	
	var max_val: float # 'Max' is short for 'maximum value' and is the largest value in the 'values' array.
	var max_val_index: int # The index of the max_val in the 'values' array.
	
	var position_range: float # This variable defines the y_position dfifference between max_val and min_val. The formula can be found below.
	
	var vector2_array: PackedVector2Array
	
	vector2_array.resize(total_point_count)
	
	min_val = values[0] # This is for the iteration of the array to work well. This makes the 'min_val' NOT be 0.
	for i in values.size():
		var value = values[i]
		if value > max_val:
			max_val_index = i
			max_val = value
		if value < min_val:
			min_val = value
			min_val_index = i
		# The for loop above cycles through the array 'values' and assigns 'min_val' and 'max_val' accordingly. (Declaration of the variables in the code above)
	
	
	match type:
		
		ChartType.LineChart: # The code below runs when the user selected 'LineChart' as the Chart Type.
			var offset = x_y_lines_width / 2
			var line_chart_x_y_indicator_point_array: PackedVector2Array = [
				Vector2(offset, 0),
				Vector2(offset, y_size - offset),
				Vector2(x_size, y_size - offset)
			]
			
			var x_increment = (x_size) / (total_point_count - 1)
			
			for i in total_point_count:
				vector2_array[i] = Vector2(
					x_increment * i, # x value
					y_size - (y_size / max_val * values[i]) # y value
					)
			draw_polyline(vector2_array, line_color, line_width, antialiasing) # Draws the main line.
			draw_polyline(line_chart_x_y_indicator_point_array, x_y_lines_color, x_y_lines_width, antialiasing) # Draws the x and y helper lines.
			
		ChartType.BarChartVertical: # The code below runs when the user selected 'BarChartVertical' as the Chart Type.
			var offset = x_y_lines_width / 2
			var line_chart_x_y_indicator_point_array: PackedVector2Array = [
				Vector2(offset, 0),
				Vector2(offset, y_size - offset),
				Vector2(x_size, y_size - offset)
			]
			
			var x_increment = (x_size - line_width - (x_y_lines_width * 2)) / (total_point_count - 1)
			
			for i in total_point_count:
					vector2_array[i] = Vector2(
						x_increment * i + (line_width / 2) + x_y_lines_width, # x value
						y_size - (y_size / max_val * values[i]) # y value
						)
					draw_line(vector2_array[i], Vector2(vector2_array[i].x, y_size), line_color, line_width, antialiasing) # Draws the main lines.
			draw_polyline(line_chart_x_y_indicator_point_array, x_y_lines_color, x_y_lines_width, antialiasing) # Draws the x and y helper lines.
			
		ChartType.BarChartHorizontal: # The code below runs when the user selected 'BarChartHorizontal' as the Chart Type. This, for now, unfortunately works only from right-to-left horizontally, not left-to-right, as intended. The add-on is still in development, though!
			var offset = x_y_lines_width / 2
			var line_chart_x_y_indicator_point_array: PackedVector2Array = [
				Vector2(x_size - offset, 0),
				Vector2(x_size - offset, y_size - offset),
				Vector2(offset, y_size - offset)
			]
			
			var y_increment = (y_size - line_width - (x_y_lines_width * 2)) / (total_point_count - 1)
			
			for i in total_point_count:
				vector2_array[i] = Vector2(
					x_size - (x_size / max_val * values[i]), # x value
					y_increment * i + (line_width / 2) + x_y_lines_width # y value
				)
				draw_line(vector2_array[i], Vector2(x_size, vector2_array[i].y), line_color, line_width, antialiasing) # Draws the main lines.
			draw_polyline(line_chart_x_y_indicator_point_array, x_y_lines_color, x_y_lines_width, antialiasing) # Draws the x and y helper lines.
