extends Node2D

signal player_entered_transition_zone

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var reversable_button: ReversableButton = $Entities/ReversableButton
@onready var reversable_lever: ReversableLever = $Entities/ReversableLever
@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")

func _ready() -> void:
	time_system._reset()


func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()


func _on_player_entered_transition_zone() -> void:
	SceneManager.next_scene()
