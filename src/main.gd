extends Node

@export var main_menu: StringName = &""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneLoader.load_scene(main_menu)
