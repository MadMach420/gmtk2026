extends StaticBody2D

enum GateDirection { UP, DOWN }

@export var object_color_code: Color = Color()
@export var open_direction: GateDirection = GateDirection.UP
@export var open_time_seconds: float = 1.0
@export var move_distance: float = 64.0 # Height of the gate in pixels

@onready var closed_position: Vector2 = global_position
@onready var opened_position: Vector2 = _get_opened_position()
@onready var move_sound: AudioStreamPlayer2D = $MoveSound
@onready var sprite_2d: Sprite2D = $Sprite2D

var _tween: Tween

func _ready() -> void:
	# Save initial position as the closed state
	closed_position = global_position
	opened_position = _get_opened_position()
	sprite_2d.modulate = object_color_code

func open() -> void:
	move_sound.play()
	_move_to(opened_position)

func close() -> void:
	move_sound.play()
	_move_to(closed_position)

func stop() -> void:
	if _tween and _tween.is_running():
		_tween.kill()

func _move_to(target_position: Vector2) -> void:
	# Stop any currently active motion tween
	if _tween and _tween.is_running():
		_tween.kill()

	# Calculate distance remaining to scale time proportionally
	var total_distance: float = closed_position.distance_to(opened_position)
	var distance_left: float = global_position.distance_to(target_position)
	
	if total_distance <= 0.0 or distance_left <= 0.0:
		return

	# Proportional duration ensures consistent speed when interrupted
	var duration: float = open_time_seconds * (distance_left / total_distance)

	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(self, "global_position", target_position, duration)

func _get_opened_position() -> Vector2:
	var dir_vector: Vector2 = Vector2.UP if open_direction == GateDirection.UP else Vector2.DOWN
	return closed_position + (dir_vector * move_distance)
