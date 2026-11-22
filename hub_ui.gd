extends CanvasLayer

const GAMES := {
	"binary": {
		"scene": "res://binary-puzzle/Main.tscn",
		"bounds": Rect2(90, 90, 420, 500),
	},
	"pipes": {
		"scene": "res://pipes/main.tscn",
		"bounds": Rect2(55, 55, 680, 680),
	},
}

const LAB_SCENE := "res://lab.tscn"
const CONTINUE_SCENE := "res://continue.tscn"

var _game: Node2D = null
var _closing: bool = false
var _after_solved: String = ""

@onready var _dim: ColorRect = $Dim
@onready var _frame: Panel = $Frame
@onready var _host: Node2D = $Host


func _ready() -> void:
	add_to_group("puzzle_popup")
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	visible = false
	_dim.visible = false
	_frame.visible = false


func is_open() -> bool:
	return _game != null


func open_game(game_id: String, after_solved: String = "") -> void:
	if _game != null or _closing:
		return
	if not GAMES.has(game_id):
		push_error("Unknown puzzle: " + game_id)
		return

	_after_solved = after_solved
	var spec: Dictionary = GAMES[game_id]
	_game = (load(spec.scene) as PackedScene).instantiate() as Node2D
	if _game.has_signal("puzzle_solved"):
		_game.connect("puzzle_solved", _on_puzzle_solved)
	_host.add_child(_game)
	_layout_popup(spec.bounds)
	visible = true
	_dim.visible = true
	_frame.visible = true
	get_tree().paused = true


func close() -> void:
	_closing = false
	if _game != null:
		if _game.has_signal("puzzle_solved") and _game.is_connected("puzzle_solved", _on_puzzle_solved):
			_game.disconnect("puzzle_solved", _on_puzzle_solved)
		_game.queue_free()
		_game = null
	visible = false
	_dim.visible = false
	_frame.visible = false
	get_tree().paused = false


func _layout_popup(bounds: Rect2) -> void:
	var view: Vector2 = get_viewport().get_visible_rect().size
	var max_size: Vector2 = view * 0.78
	var scale_factor: float = minf(max_size.x / bounds.size.x, max_size.y / bounds.size.y)
	scale_factor = minf(scale_factor, 1.0)
	_game.scale = Vector2(scale_factor, scale_factor)
	var scaled_size: Vector2 = bounds.size * scale_factor
	_game.position = (view - scaled_size) / 2.0 - bounds.position * scale_factor
	var margin := Vector2(28, 28)
	_frame.position = _game.position + bounds.position * scale_factor - margin
	_frame.size = scaled_size + margin * 2.0


func _on_puzzle_solved() -> void:
	if _closing:
		return
	_closing = true
	var after := _after_solved
	var timer := get_tree().create_timer(0.55, true, false, true)
	await timer.timeout
	close()
	if after == "lab":
		get_tree().change_scene_to_file(LAB_SCENE)
	elif after == "continue":
		get_tree().change_scene_to_file(CONTINUE_SCENE)
