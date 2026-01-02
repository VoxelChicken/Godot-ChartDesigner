@icon("res://addons/chartdesigner/LineGraph2D.png")

## The ChartDesigner is the Add-on alternative to writing your own charts. It makes making charts simple and easy. To set up the size of the desired chart, you just have to set up the control node to the desired size of the chart.
## Follow up with a glance at the inspector - it has the variables required for designing the desired chart, and most importantly, it contains the [code]PackedFloat64Array[/code] for the points
## (in the inspector, the 'values' array isn't a [code]PackedVector2Array[/code], which the Godot's [code]Line2D[/code] uses, but rather a [code]PackedFloat64Array[/code]. This is because the only thing the user has to do is give the graph the values, because the regular increments on the x axis are done automatically calculated).
## The variables, apart from the [code]PackedFloat64Array[/code], include:[br][br]
## Line Color,[br]
## x and y Lines Color,[br]
## Line Width,[br]
## Anti-aliasing,[br][br]
## and so on. (Below - under 'Properties' - you'll  find the rest of them.)[br][br]
## Tune these to your preference and you have yourself an easy chart, enjoy![br][br]
## It is advisable to play around and change the variables at will to learn about each of the settings and what they change (additionally, nothing prevents you from glancing at the code, if you so please).[br][br]
## (Note: This is an open-source passion project by a solo developer. Updates are most likely not going to appear at regular intervals, but rather, at random.)
class_name ChartDesigner
extends Control

enum ChartType{
	LineGraph,
	BarChart
}

# The line(s) with '##' in the beginning means that they show up in the docs for this class.

## This exported enum gives you a drop-down menu containing different chart types.
@export var type: ChartType


## This group holds the settings for the LineGraph and BarChart.
@export_group("LineChart & BarChart")

## The 'values' array is the array for the values displayed on the y axis in the Graph.
## It is also exported to the inspector on the right side of the screen (default setting). When you first get the add-on, there aren't any valuables set to this array, so you have to enter AT LEAST 2 values.
@export var values: PackedFloat64Array

## With this color, you can choose which color you want the line or columns (bars) to have.
@export var line_color: Color = Color.RED
## With this color you can choose your desired width of the x and y line's width. Setting it to -1 makes the line as thin as possible, in some cases, even less than 1 pixel wide.
@export var x_y_lines_color: Color = Color.BLACK

## With this color you can choose your desired width of the line width. Setting it to -1 makes the line as thin as possible, in some cases, even less than 1 pixel wide.
@export var line_width: float = 5
## This variable is the width of the background lines that indicate the x and y axes.
@export var x_y_lines_width: float = 10

## With this variable (originally intended for bar charts, however you can use this for line graphs just the same), you can define the distance between the first and last bar (column) to the edge (y axis line).
@export var distance_to_y: float

## This is the antialiasing [code] bool [/code]. It's also exported to the inspector. The antialiasing makes the pixelated lines smooth if '[code] True [/code]' ('On').
@export var antialiasing: bool = true

## When this is on, numbers will appear on the edges of the LineGraph and BarChart.
@export var number_labels: bool = true

## Choose the font size of the numbers on the edges of the LineGraph or BarChart.
@export var number_font_size: float = 20

## Choose the font color of the numbers on the edges of the LineGraph or BarChart.
@export var number_color: Color = Color.BLACK

## This variable lets you choose if you want helper lines, so the close to invisible lines in the LineGraph, indicating where values roughly are.
## The only value that won't be accepted is
@export var helper_line_amount: int

## Choose your color for the helper lines.
@export var helper_line_color: Color = Color.BLACK

## Choose your width for the helper_lines.
@export var helper_line_width: float = 2.0

## With this variable, you can adjust the helper numbers on the left side of the LineGraph or BarChart.
@export var helper_number_adjustment: float = 60

## Antialiasing for the helper lines.
@export var helper_line_antialiasing: bool = true

## The color for the background of the LineGraph or BarChart. If you don't like the background, just set it to completely transparent (#00000000).
@export var background_color: Color = Color.TRANSPARENT

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
	if values.is_empty():
		push_warning(
		"Not enough values entered! If you entered none, please add at least two!"
		) # Error handling. if there aren't any values whatsoever, this message tells you.
		return
		
	elif len(values) < 2:
		push_warning(
		"Not enough values entered! If you merely typed in one single value, please fix it and make at least two out of it."
		) # Error handling. if there is only one value set, this message tells you.
		return
		
	var total_point_count: int = len(values)
	
	var x_size := get_rect().size.x
	var y_size := get_rect().size.y
	
	var min_val: float # 'Min' is short for 'minimum value' and is the smallest value in the 'values' array.
	var min_val_index: int # The index of the min_val in the 'values' array.
	
	var max_val: float # 'Max' is short for 'maximum value' and is the largest value in the 'values' array.
	var max_val_index: int # The index of the max_val in the 'values' array.
	
	var position_range: float # This variable defines the y_position dfifference between max_val and min_val. The formula can be found below.
	
	var vector2_array: PackedVector2Array # For the lines. This where the point positions get stored.
	
	var default_font := ThemeDB.fallback_font; # Puts the default font into a variable for the draw_string() functions.
	
	vector2_array.resize(total_point_count) # Makes the 'vector2_array' as big as the 'values' array.
	
	var helper_line_y_val: float # Helps the creation of the y lines by assigning this to 'max_val / 3'
	
	min_val = values[0] # This is for the iteration of the array to work well. This makes the 'min_val' NOT be 0.
	for i in values.size():
		var value := values[i]
		if value > max_val:
			max_val_index = i
			max_val = value
		if value < min_val:
			min_val = value
			min_val_index = i
		# The for loop above cycles through the array 'values' and assigns 'min_val' and 'max_val' accordingly. (Declaration of the variables in the code above)
	
	draw_rect(Rect2(Vector2(0, 0), Vector2(x_size, y_size)), background_color, true, -1, false) # Draws the background of the LineGraph and BarChart.
	
	match type:
		
		ChartType.LineGraph: # The code below runs when the user selected 'LineChart' as the Chart Type.
			var offset := x_y_lines_width / 2
			var line_chart_x_y_indicator_point_array: PackedVector2Array = [
				Vector2(offset, 0),
				Vector2(offset, y_size - offset),
				Vector2(x_size, y_size - offset)
			]
			
			var x_increment = (x_size - line_width - distance_to_y) / (total_point_count - 1) # Sets the x_increment for the point positions.x.
			
			for i in total_point_count:
				vector2_array[i] = Vector2( # This simply initializes a PackedVector2Array with the following values:
					x_increment * i + (distance_to_y / 2) + (line_width / 2), # x value
					y_size - (y_size / max_val * values[i]) - (line_width / 2) # y value
					)
			draw_polyline(vector2_array, line_color, line_width, antialiasing) # Draws the main line.
			draw_polyline(line_chart_x_y_indicator_point_array, x_y_lines_color, x_y_lines_width, antialiasing) # Draws the x and y axis lines.
			
			if helper_line_amount >= 2: # Checks if there's less than 1 helper_lines set, and if there are less, then it won't draw anything.
				for i in helper_line_amount:
					draw_line(
						Vector2(offset, i * (y_size / helper_line_amount)),
						Vector2(x_size, i * (y_size / helper_line_amount)),
						helper_line_color, helper_line_width, helper_line_antialiasing
					)
			elif helper_line_amount == 0:
				pass
			elif helper_line_amount < 2:
				push_warning("Sorry - couldn't draw the helper_lines, since it doesn't make sense that there's only one (or a negative value)! Please input '0' if none, and more than '1' if you want some!")
			
			
			if number_labels:
				var text_size_max := default_font.get_multiline_string_size(str(max_val), HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size)
				var text_size_zero := default_font.get_multiline_string_size("0", HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size)
				
				draw_string(default_font, Vector2((text_size_max.x * -0.5), (number_font_size * -1)), str(max_val), HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size, number_color)
				
				
				for index in vector2_array.size():
					draw_string(default_font, Vector2(vector2_array[index].x - (text_size_zero.x / 2), y_size + text_size_zero.y), str(index), HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size, number_color)
					
					draw_string(
						default_font, # Font
						Vector2(
							text_size_zero.x - helper_number_adjustment,
							float(y_size) - float(index) * (float(y_size) / float(helper_line_amount)) + (text_size_zero.y / 4.0)
						), # Position
						str((max_val / helper_line_amount * index)), # Contains [String]
						HORIZONTAL_ALIGNMENT_CENTER, # Alignment
						-1, # Width
						number_font_size, # Font Size
						number_color # Color
					) # The draw_string() function above draws the helper_numbers on the left side of LineGraph.
					
			# The code above draws the LineGraph.
			
			# LineGraph
	# ----------------------------------------------------------------------------------------------------------------------------------------------------
			# BarChart
			
		ChartType.BarChart: # The code below runs when the user selected 'BarChart' as the Chart Type.
			var offset := x_y_lines_width / 2 # Makes the code nicer to look at
			var line_chart_x_y_indicator_point_array: PackedVector2Array = [
				Vector2(offset, 0),
				Vector2(offset, y_size - offset),
				Vector2(x_size, y_size - offset)
			] # This array sets the point positions of the x and y axes lines.
			
			var x_increment = (x_size - line_width - x_y_lines_width - (distance_to_y)) / (total_point_count - 1)
			
			for i in total_point_count:
				vector2_array[i] = Vector2(
					(x_increment * i) + x_y_lines_width + (line_width / 2) + (distance_to_y / 2), # x value
					y_size - (y_size / max_val * values[i]) # y value
					)
				draw_line(vector2_array[i], Vector2(vector2_array[i].x, y_size - x_y_lines_width), line_color, line_width, antialiasing) # Draws the main lines.
			draw_polyline(line_chart_x_y_indicator_point_array, x_y_lines_color, x_y_lines_width, antialiasing) # Draws the x and y helper lines.
			
			if helper_line_amount > 2:
				for i in helper_line_amount:
					draw_line(
						Vector2(offset, i * (y_size / helper_line_amount)),
						Vector2(x_size, i * (y_size / helper_line_amount)),
						helper_line_color, helper_line_width, helper_line_antialiasing
					)
			
			if number_labels:
				var text_size_max := default_font.get_multiline_string_size(str(max_val), HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size) # Stores the size of the string of the maximum value. Makes the offsetting for other stuff easier.
				var text_size_zero := default_font.get_multiline_string_size("0", HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size) # Stores the size of the string "0". Makes the offsetting for other stuff easier.
				
				draw_string(default_font, Vector2((text_size_max.x * -0.5), (number_font_size * -1)), str(max_val), HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size, number_color) # Draws the maximum value on top of the LineGraph / BarChart.
				
				for index in vector2_array.size():
					draw_string(default_font, Vector2(vector2_array[index].x - (text_size_zero.x / 2), y_size + text_size_zero.y), str(index), HORIZONTAL_ALIGNMENT_CENTER, -1, number_font_size, number_color)
					
					draw_string(
						default_font, # Font
						Vector2(
							text_size_zero.x - helper_number_adjustment,
							float(index) * (float(y_size) / float(helper_line_amount)) + (text_size_zero.y / 4.0)
						), # Position
						str((max_val / helper_line_amount * index)), # Contains the value of the helper_line that it's next to.
						HORIZONTAL_ALIGNMENT_CENTER, # Alignment
						-1, # Width
						number_font_size, # Font Size
						number_color # Color
					) # The draw_string() function above draws the helper_numbers on the left side of BarChart.
					
				# The code above draws the BarChart.
