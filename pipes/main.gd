extends Node2D

# end pipes can't rotate

var pipe_scene = preload("res://Pipe.tscn")
var pipes: Array[Pipe] = []

const parts = ["e", "s", "c", "c", "s", "s", "c", "c", "s", "c", "s", "c", "c", "s", "c", "s", "s", "c", "s", "s", "s", "c", "c", "c", "s", "c", "c", "c", "s", "c", "c", "c", "s", "s", "c", "c", "s", "s", "c", "c", "c", "s", "e", "s", "s", "s", "c", "c", "c"]
const correct_rotation = [0, 0, 270, 180, 0, 0, 270, 180, 0, 0, 90, 180, 270, 90, 90, 0, 0, 0, 90, 90, 90, 180, 270, 180, 0, 0, 90, 0, 90, 90, 0, 180, 0, 0, 270, 90, 0, 0, 0, 180, 270, 90, 0, 0, 0, 0, 0, 90, 0]

#const parts = ["e", "c", "c", "s", "i", "i", "c", "c", "e"]
#const correct_rotation = [0, 180, 270, 90, 90, 270, 90, 0, 180]
var correct_parts = []
var size = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in correct_rotation:
		correct_parts.append(false)
	spawn_pipes()

func spawn_pipes():
	pipes.clear()
	for child in get_children():
		if child is Pipe:
			child.free()
	for i in len(parts):
		var pipe = pipe_scene.instantiate() as Pipe
		var x_offset = 0
		var y_offset = 0
		if (i)%size != 0:
			x_offset = ((i)%size)*90
		y_offset = floor(i/size)*90
		var type = parts[i]
		pipe.pipe_rotated.connect(_on_pipe_rotated)
		pipe.setup(type, x_offset, y_offset, i)
		add_child(pipe)
		pipes.append(pipe)

func _on_pipe_rotated(pipe: float, rotation: float, kind: String):
	var correct = true
	if kind == "s":
		if (correct_rotation[pipe] == snapped(rad_to_deg(rotation), 0.1)) or (correct_rotation[pipe] == wrapf(snapped(rad_to_deg(rotation)+180, 0.1), 0, 360)):
			correct_parts[pipe] = true
	elif correct_rotation[pipe] == snapped(rad_to_deg(rotation), 0.1):
		correct_parts[pipe] = true
	else:
		correct_parts[pipe] = false
	for i in len(correct_parts):
		if correct_parts[i] == false:
			correct = false
	if correct == true:
		print("correct!")
