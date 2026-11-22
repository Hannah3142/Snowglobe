extends StaticBody2D

@export var game_id: String = "binary"
@export var after_solved: String = ""
@export var box_color: Color = Color(0.12, 0.42, 0.62, 0.95)

@onready var _fill: Polygon2D = $Polygon2D
@onready var _outline: Polygon2D = $Outline


func _ready() -> void:
	input_pickable = true
	_fill.color = box_color
	_outline.color = Color(0.7, 0.9, 1, 0.95)


func _open() -> void:
	var popup := get_tree().get_first_node_in_group("puzzle_popup")
	if popup == null:
		return
	if popup.has_method("is_open") and popup.is_open():
		return
	popup.open_game(game_id, after_solved)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_open()


func _on_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		_open()
