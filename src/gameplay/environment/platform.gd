extends AnimatableBody2D

enum MoveDirection { UP, DOWN, LEFT, RIGHT }

@export var direction: MoveDirection = MoveDirection.RIGHT
@export var move_distance: float = 128.0 # Distance in pixels the platform moves
@export var travel_time_seconds: float = 2.0

var retracted_position: Vector2
var extended_position: Vector2
var active_tween: Tween

func _ready() -> void:
	# Store the starting resting position
	retracted_position = global_position
	
	# Determine offset vector based on chosen direction
	var offset: Vector2 = Vector2.ZERO
	match direction:
		MoveDirection.UP:
			offset = Vector2(0, -move_distance)
		MoveDirection.DOWN:
			offset = Vector2(0, move_distance)
		MoveDirection.LEFT:
			offset = Vector2(-move_distance, 0)
		MoveDirection.RIGHT:
			offset = Vector2(move_distance, 0)
			
	extended_position = retracted_position + offset

## Extends the platform outward to its target destination
func extend_platform() -> void:
	_move_to(extended_position)

## Retracts the platform back to its starting home position
func retract_platform() -> void:
	_move_to(retracted_position)

## Stops movement instantly mid-animation
func stop_platform() -> void:
	if active_tween and active_tween.is_running():
		active_tween.kill()

## Toggles direction based on whichever destination is closer
func toggle_platform() -> void:
	var dist_to_extended = global_position.distance_to(extended_position)
	var dist_to_retracted = global_position.distance_to(retracted_position)
	
	if dist_to_extended < dist_to_retracted:
		retract_platform()
	else:
		extend_platform()

# Smoothly transitions to a target vector with speed scaling
func _move_to(target_pos: Vector2) -> void:
	if active_tween and active_tween.is_running():
		active_tween.kill()

	var remaining_distance: float = global_position.distance_to(target_pos)
	
	if remaining_distance <= 0.1:
		return

	# Scales travel duration so speed stays constant even if interrupted mid-way
	var move_duration: float = (remaining_distance / move_distance) * travel_time_seconds

	active_tween = create_tween()
	active_tween.set_trans(Tween.TRANS_SINE)
	active_tween.set_ease(Tween.EASE_IN_OUT)
	active_tween.tween_property(self, "global_position", target_pos, move_duration)
