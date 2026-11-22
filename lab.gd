extends Node2D

@onready var _background: Sprite2D = $Background
@onready var _camera: Camera2D = $Camera2D
@onready var _player: CharacterBody2D = $Player
@onready var _table_box: Node2D = $BinaryPuzzleBox
@onready var _floor: StaticBody2D = $Floor


func _ready() -> void:
	var view: Vector2 = get_viewport().get_visible_rect().size
	_camera.position = view / 2.0
	_camera.make_current()

	var tex: Texture2D = _background.texture
	if tex:
		var tex_size: Vector2 = tex.get_size()
		var cover: float = maxf(view.x / tex_size.x, view.y / tex_size.y)
		_background.position = view / 2.0
		_background.scale = Vector2(cover, cover)

	# Table surface in the station painting (right-hand workbench).
	_table_box.position = Vector2(view.x * 0.77, view.y * 0.655)
	_table_box.scale = Vector2(0.4, 0.4)
	_player.position = Vector2(view.x * 0.24, view.y * 0.80)
	_floor.position = Vector2(view.x * 0.5, view.y * 0.90)
