extends Node2D

signal puzzle_solved

var field_scene = preload("Field.tscn")
var fields: Array[Field] = []
var _solved: bool = false

"""
-1, -1, 0, 0, -1, -1, -1, -1, -1, -1
-1, -1, -1, -1, -1, -1, 1, -1, -1, 0
-1, -1, 0, -1, 1, -1, -1, 0, -1, 0
-1, 1, -1, 1, -1, 1, -1, -1, -1, -1
-1, 1, -1, 0, -1, -1, -1, 1, -1, -1
-1, -1, 0, -1, -1, -1, 0, -1, 1, -1
-1, -1, -1, -1, 0, -1, 1, -1, 0, -1
1, -1, 0, -1, -1, 1, -1, 0, -1, -1
1, -1, -1, 1, -1, -1, -1, -1, -1, -1
-1, -1, -1, -1, -1, -1, 0, 0, -1, -1

1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 
0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 
1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 
0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 
0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 
1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 
0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 
1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 
1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 
0, 0, 1, 0, 1, 1, 0, 0, 1, 1
"""

var values = [-1, -1, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1, -1, -1, 0, -1, -1, 0, -1, 1, -1, -1, 0, -1, 0, -1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, -1, 0, -1, -1, -1, 1, -1, -1, -1, -1, 0, -1, -1, -1, 0, -1, 1, -1, -1, -1, -1, -1, 0, -1, 1, -1, 0, -1, 1, -1, 0, -1, -1, 1, -1, 0, -1, -1, 1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1]
var solution = [1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1] #!!
var size = int(sqrt(len(values)))

var x_offset = 0
var y_offset = 0

func _ready() -> void:
	queue_redraw()
	spawn_text_fields()
	_add_rules()


func _add_rules() -> void:
	var rules := Label.new()
	rules.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rules.position = Vector2(95, 512)
	rules.size = Vector2(400, 118)
	rules.autowrap_mode = TextServer.AUTOWRAP_OFF
	rules.add_theme_font_size_override("font_size", 15)
	rules.add_theme_constant_override("line_spacing", 3)
	rules.add_theme_color_override("font_color", Color(0.85, 0.96, 1, 1))
	rules.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	rules.text = "Fill blanks with 0 or 1.  Click to cycle.
Five 0s and five 1s in every row and column.
No more than two identical numbers in a row.
No duplicate rows or columns."
	add_child(rules)

func spawn_text_fields():
	fields.clear()
	for child in get_children():
		if child is Field:
			child.free()
	for i in len(values):
		var field = field_scene.instantiate() as Field
		x_offset = 0
		y_offset = 0
		if i%size != 0:
			x_offset = (i%size)*40
		y_offset = floor(i/size)*40
		field.clicked.connect(_on_field_clicked)
		field.setup(values[i], i, x_offset, y_offset)
		add_child(field)
		fields.append(field)

func _draw():
	for i in len(values):
		x_offset = (i%size)*40+95
		y_offset = floor(i/size)*40+102
		draw_rect(Rect2(x_offset, y_offset, 40.0, 40.0), Color.GRAY, false, 1.0)

func _on_field_clicked(index: int, new_value: int):
	var right = true
	values[index] = new_value
	for i in len(values):
		if values[i] != solution[i]:
			right = false
	if right == true and not _solved:
		_solved = true
		print("correct!")
		puzzle_solved.emit()
