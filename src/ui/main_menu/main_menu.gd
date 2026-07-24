extends Control

@export var initial_scene: StringName = &""
@export var new_game_button: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_new_game_pressed() -> void:
	SceneLoader.load_scene(initial_scene)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
