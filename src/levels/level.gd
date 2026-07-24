extends Node2D

signal player_entered_transition_zone

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var reversable_button: ReversableButton = $Entities/ReversableButton
@onready var reversable_lever: ReversableLever = $Entities/ReversableLever
@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")
@export var restart_timeout_s: float = 0.2

var restart_pressed_timer: Timer = Timer.new()

func _ready() -> void:
	time_system._reset()
	add_child(restart_pressed_timer)
	restart_pressed_timer.one_shot = true
	restart_pressed_timer.timeout.connect(_on_restart_pressed_timer_timeout)

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_level") and restart_pressed_timer.is_stopped():
		restart_pressed_timer.start(restart_timeout_s)
	if !Input.is_action_pressed("restart_level") and not restart_pressed_timer.is_stopped():
		restart_pressed_timer.stop()

func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()


func _on_player_entered_transition_zone() -> void:
	SceneManager.next_scene()
	
func _on_restart_pressed_timer_timeout() -> void:
	SceneManager.reload_level()
