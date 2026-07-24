extends Node2D

signal player_entered_transition_zone

@onready var next_level_trigger: Area2D = $NextLevelTrigger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Palyer in")
		player_entered_transition_zone.emit()
