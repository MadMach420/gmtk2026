extends Node2D

signal player_entered_transition_zone

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var label: Label = $Entities/Label
@onready var reversable_button: ReversableButton = $Entities/ReversableButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reversable_button.toggled.connect(func(is_pressed: bool): label.text = "1" if is_pressed else "0")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Palyer in")
		player_entered_transition_zone.emit()
