extends Node2D
class_name Level

signal player_entered_transition_zone

@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")
@export var restart_timeout_s: float = 0.2

var restart_pressed_timer: Timer = Timer.new()

func _ready() -> void:
	time_system._reset()
	add_child(restart_pressed_timer)
	restart_pressed_timer.one_shot = true
	restart_pressed_timer.timeout.connect(_on_restart_pressed_timer_timeout)
	
	player_entered_transition_zone.connect(_on_player_entered_transition_zone)

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_level") and restart_pressed_timer.is_stopped():
		restart_pressed_timer.start(restart_timeout_s)
	if !Input.is_action_pressed("restart_level") and not restart_pressed_timer.is_stopped():
		restart_pressed_timer.stop()

func _on_player_entered_transition_zone() -> void:
	SceneManager.next_scene()
	
func _on_restart_pressed_timer_timeout() -> void:
	SceneManager.reload_level()
