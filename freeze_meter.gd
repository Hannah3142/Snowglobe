extends CanvasLayer

const HUB_SCENE := "res://node_2d.tscn"
const WATER_SECONDS_TO_FREEZE := 50.0
const LAND_SECONDS_TO_THAW := 15.0

var freeze: float = 0.0
var _restarting: bool = false

@onready var _bar: ProgressBar = $Root/Bar
var _fill_style: StyleBoxFlat


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 40
	_bar.value = 0.0
	var existing := _bar.get_theme_stylebox("fill")
	if existing is StyleBoxFlat:
		_fill_style = (existing as StyleBoxFlat).duplicate() as StyleBoxFlat
		_bar.add_theme_stylebox_override("fill", _fill_style)


func _process(delta: float) -> void:
	if _restarting:
		return
	var player := get_tree().get_first_node_in_group("player")
	var in_water: bool = player != null and bool(player.get("is_in_water"))
	if in_water:
		freeze += delta / WATER_SECONDS_TO_FREEZE
	else:
		freeze -= delta / LAND_SECONDS_TO_THAW
	freeze = clampf(freeze, 0.0, 1.0)
	_bar.value = freeze * 100.0
	_update_fill_color()
	if freeze >= 1.0:
		_restart()


func _update_fill_color() -> void:
	if _fill_style == null:
		return
	_fill_style.bg_color = Color(0.55, 0.85, 1.0, 1.0).lerp(Color(0.92, 0.97, 1.0, 1.0), freeze)


func _restart() -> void:
	_restarting = true
	get_tree().paused = false
	get_tree().change_scene_to_file(HUB_SCENE)
