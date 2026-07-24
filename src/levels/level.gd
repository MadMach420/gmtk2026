extends Node2D

signal player_entered_transition_zone

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var reversable_button: ReversableButton = $Entities/ReversableButton
@onready var reversable_lever: ReversableLever = $Entities/ReversableLever

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Palyer in")
		player_entered_transition_zone.emit()
