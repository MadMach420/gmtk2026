extends Node
class_name TimeSystem

## Signals for first level loop iteration
signal loop_ended
signal loop_started

## Signals for rewind part of the loop
signal rewind_started
signal rewind_ended

@export var loop_length_s = 60

var loop_timer = Timer.new()
var rewind_timer = Timer.new()
var is_rewinding = false
var has_loop_ended = false 

func _init_timer(timer: Timer, timeout_func: Callable) -> void:
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(timeout_func)

## Reset the timers
func _reset() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_timer(loop_timer, _on_loop_timer_timeout)
	_init_timer(rewind_timer, _on_rewind_timer_timeout)

func _start_loop() -> void:
	is_rewinding = false
	loop_started.emit()
	loop_timer.start(loop_length_s)
	
func _start_rewind() -> void:
	is_rewinding = true
	rewind_started.emit()
	rewind_timer.start(loop_length_s)

## Returns time left to end on normal loop
## Returns time left to start on rewind loop
func get_current_time_left() -> float:
	if not is_rewinding:
		if not loop_timer.is_stopped():
			return loop_timer.time_left
		else: return 0.0
	else: # is rewinding
		if not rewind_timer.is_stopped():
			return loop_length_s - rewind_timer.time_left
		else: return loop_length_s
	
	return -1 # to sie nie powinno wydarzyc, jak bedzie -1 to sie bedziemy martwic

func _on_loop_timer_timeout():
	print("Loop timer ended - Rewinding time")
	loop_ended.emit()
	
func _on_rewind_timer_timeout():
	print("Rewind timer ended - Check if player won or not")
	rewind_ended.emit()
	
func start_timer():
	if not has_loop_ended and loop_timer.is_stopped():
		_start_loop()
	elif has_loop_ended and rewind_timer.is_stopped():
		_start_rewind()

func _on_loop_ended() -> void:
	has_loop_ended = true
