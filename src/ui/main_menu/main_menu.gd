extends Control

@export var initial_scene: StringName = &""
@export var new_game_button: Button

@onready var soundtrack_system: SoundtrackSystem = Systems.get_node("%SoundtrackSystem")

func _ready() -> void:
	soundtrack_system.set_menu_volume()


func _on_new_game_pressed() -> void:
	soundtrack_system._set_normal()
	SceneManager.load_first_level()


func _on_exit_pressed() -> void:
	get_tree().quit()
