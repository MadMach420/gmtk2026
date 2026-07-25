"""
Block zone that blocks the player from entering it until the rewind has started.
The user must draw the Collision polygon, then copy it and paste into the visual polygon.
"""
extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var time_system: TimeSystem = Systems.get_node("%TimeSystem")


func _ready() -> void:
	time_system.rewind_started.connect(_on_rewind_started)

func _on_rewind_started() -> void:
	animation_player.play("fadeout")
