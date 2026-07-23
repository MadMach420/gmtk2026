extends Node2D
class_name ReversableObject


@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")

# Example snapshot will look like: { "time": 45.2, "data": { "pos": Vector2(...) } }
var timeline: Array[Dictionary] = []
var is_rewinding: bool = false
var current_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_system.start_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time := time_system.get_current_time_left()
	var time_int_part = int(time)
	if time > 0:
		pass
