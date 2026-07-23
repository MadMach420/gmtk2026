extends Node2D
class_name ReversibleObject

@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")

var timeline = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_system.start_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = time_system.get_current_time_left()
	if time > 0:
		pass
