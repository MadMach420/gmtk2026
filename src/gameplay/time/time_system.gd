extends Node
class_name TimeSystem

signal loop_ended
signal loop_started

@export var loop_length_s = 60

var loop_timer = Timer.new()
var is_rewinding = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(loop_timer)
	loop_timer.one_shot = true
	loop_timer.timeout.connect(_on_loop_timer_timeout)

func start_time() -> void:
	is_rewinding = false
	loop_started.emit()
	loop_timer.start(loop_length_s)
	
func get_current_time_left() -> float:
	if not loop_timer.is_stopped():
		return loop_timer.time_left
	return 0.0

func _on_loop_timer_timeout():
	is_rewinding = true
	print("Loop timer ended - Rewinding time")
	loop_ended.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
