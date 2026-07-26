extends "res://src/gameplay/time/reversable_platform.gd"

@export var lever: ReversableLever

func _ready() -> void:
	super._ready()
	lever.toggled.connect(_on_lever_toggled)
	time_system.loop_ended.connect(_on_loop_ended)
	time_system.rewind_ended.connect(_on_rewind_ended)

func _on_loop_ended(delta: float) -> void:
	animation_player.pause()

func _on_rewind_ended() -> void:
	animation_player.pause()

func _start_rewind() -> void:
	super._start_rewind()

func _on_lever_toggled(is_pressed: bool) -> void:
	if is_pressed:
		animation_player.play("rotate")
	else:
		animation_player.play_backwards("rotate")
