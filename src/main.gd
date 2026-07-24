extends Node

@export var main_menu: StringName = &""
var debug_scene = "uid://5buc5jqkuv8y"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager._ready()
	#SceneLoader.load_finished.connect()
