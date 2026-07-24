extends Node2D

@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")
@onready var clock_hand: Sprite2D = $ClockHand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clock_hand.rotate(PI)

func calculate_hand_rotation_radians(time_left: float, total_time: float) -> float:
	return PI - 2 * PI * time_left / total_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_left: float = ceil(time_system.get_current_time_left())
	var rotation := calculate_hand_rotation_radians(time_left, time_system.loop_length_s)
	clock_hand.global_rotation = rotation
