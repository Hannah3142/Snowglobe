extends CanvasLayer

const HUB_SCENE := "res://node_2d.tscn"


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_back_pressed() -> void:
	var popup := get_tree().get_first_node_in_group("puzzle_popup")
	if popup != null and popup.has_method("close"):
		popup.close()
		return
	get_tree().change_scene_to_file(HUB_SCENE)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
		get_viewport().set_input_as_handled()
