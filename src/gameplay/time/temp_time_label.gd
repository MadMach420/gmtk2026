extends Label


@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(int(time_system.get_current_time_left()))
