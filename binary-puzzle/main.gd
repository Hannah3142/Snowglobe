extends Node2D

var field_scene = preload("Field.tscn")
var fields: Array[Field] = []

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
	if right == true:
		print("correct!")
