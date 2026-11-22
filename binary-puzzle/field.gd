extends Node2D

class_name Field
var text_field: Label

#values[i], i, x_offset, y_offset
@export var v: float
@export var n: float
@export var x: float
@export var y: float

# set up signal when clicked
var unchangable = []
var number = 0
var value = 0
signal clicked(index: int, new_value: int)

# Called when the node enters the scene tree for the first time.
func setup(v: float, n: float, x: float, y: float) -> void:
	value = v
	number = n
	var x_offset = x
	var y_offset = y
	text_field = Label.new()
	text_field.add_theme_font_size_override("font_size", 30)
	
	if value < 0:
		text_field.text = "   "
	else:
		text_field.text = " " + str(int(value)) + " "
		unchangable.append(number)
		text_field.add_theme_color_override("font_color", Color.AQUAMARINE)
		text_field.add_theme_constant_override("outline_size", 3)
		text_field.add_theme_color_override("font_outline_color", Color.AQUAMARINE)
	
	add_child(text_field)
	position = Vector2(100+x_offset, 100+y_offset)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_global_mouse_position()
		if text_field.get_global_rect().has_point(mouse_position) and number not in unchangable:
			value = wrapf(value+1, -1, 2)
			if value < 0:
				text_field.text = "   "
			else:
				text_field.text = " " + str(int(value)) + " "
			clicked.emit(number, value)
