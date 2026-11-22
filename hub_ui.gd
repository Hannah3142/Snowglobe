extends CanvasLayer

const BINARY_PUZZLE_SCENE := "res://binary-puzzle/Main.tscn"
const PIPES_SCENE := "res://pipes/main.tscn"


func _on_binary_puzzle_pressed() -> void:
	get_tree().change_scene_to_file(BINARY_PUZZLE_SCENE)


func _on_pipes_pressed() -> void:
	get_tree().change_scene_to_file(PIPES_SCENE)
