extends Node2D

var score = 0
var reverse_time: bool = false

@onready var label: Label = $Label
@onready var level_timer: Timer = $LevelTimer

func add_point():
	score += 1
	label.text = "%03d" % score
	
func add_points(points: int):
	score += points
	label.text = "%03d" % score

func _process(delta: float) -> void:
	label.text = "%d" % level_timer.time_left
	
	
func _on_level_timer_timeout() -> void:
	reverse_time = true
