extends CanvasLayer

@onready var time_system: TimeSystem = Systems.get_node("TimeSystem")
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str(time_system.loop_length_s)
	label.modulate.a = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(int(ceil(time_system.get_current_time_left())))
