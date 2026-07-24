extends Node2D
class_name Vanishable

@export var timeout_value: float = 0.0
@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_system.loop_started.connect(_vanish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _vanish() -> void:
	await get_tree().create_timer(timeout_value).timeout
	queue_free()
