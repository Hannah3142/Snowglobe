extends Node2D

var sprite: Sprite2D

@export var t: String
@export var x: float
@export var y: float
@export var n: float

var number = 0
var type = ""
signal pipe_rotated(pipe: float, rotation: float, kind: String)

func setup(t: String, x: float, y: float, n: float) -> void:
	type = t
	var x_offset = x
	var y_offset = y
	number = n
	sprite = Sprite2D.new()

	if type == "e":
		sprite.texture = load("res://assets/pipes/assets/end.png")
	if type == "s":
		sprite.texture = load("res://assets/pipes/assets/straight.png")
	if type == "i":
		sprite.texture = load("res://assets/pipes/assets/intersection.png")
	if type == "c":
		sprite.texture = load("res://assets/pipes/assets/corner.png")

	add_child(sprite)
	scale.x = 0.3
	scale.y = 0.3
	position = Vector2(100+x_offset, 100+y_offset)
	pipe_rotated.emit(number, rotation, type)

func _input(event):
	if sprite == null or not is_instance_valid(sprite) or not is_inside_tree():
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = sprite.to_local(get_global_mouse_position())
		if sprite.get_rect().has_point(mouse_position):
			rotation += deg_to_rad(90)
			rotation = wrapf(rotation, 0, 2*PI)
			#print("emit ", number, " ", rotation)
			pipe_rotated.emit(number, rotation, type)
			#number alwas wrong
