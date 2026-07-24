extends Node

const MAIN_MENU_PATH: NodePath = "res://src/ui/main_menu/MainMenu.tscn"
const BEGGINING_CUTSCENE_PATH = "" # nalezy to wypelnic
const LEVEL_PATHS_IN_ORDER: Array[NodePath] = [
	"res://src/levels/BaseLevel.tscn",
	"res://src/levels/TestLevelTransition.tscn"
]
const FINAL_CUTSCENE_PATH = "" # nalezy to wypelnic

var current_scene_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	SceneLoader.load_scene(MAIN_MENU_PATH)

func load_beginning_cutscene() -> void:
	SceneLoader.load_scene(BEGGINING_CUTSCENE_PATH)

func load_first_level() -> void:
	SceneLoader.load_scene(LEVEL_PATHS_IN_ORDER[0])

func next_scene() -> void:
	current_scene_index += 1
	if current_scene_index >= len(LEVEL_PATHS_IN_ORDER):
		SceneLoader.load_scene(FINAL_CUTSCENE_PATH)
		return

	SceneLoader.load_scene(LEVEL_PATHS_IN_ORDER[current_scene_index])
