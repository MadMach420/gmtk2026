extends ReversableObject
class_name ReversableBox

@onready var body: RigidBody2D = $RigidBody2D

## Take a snapshot every time the box moves `> snapshot_distance` pixels
@export var snapshot_distance = 2

var last_recorded_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_record_state()
	last_recorded_position = body.global_position

func _is_state_changing() -> bool:
	var distance = body.global_position.distance_to(last_recorded_position)
	# Snapshot every time the box moves > X pixels
	if distance > snapshot_distance:
		last_recorded_position = body.global_position
		return true
	return false

func _get_state_data() -> Dictionary:
	return {
		"position": body.global_position,
		"rotation": body.global_rotation,
	}

func _apply_state_data(data: Dictionary, duration: float) -> void:
	current_tween.tween_property(
		body, "global_position", data["position"], duration
	)
	current_tween.parallel().tween_property(
		body, "global_rotation", data["rotation"], duration
	)


func apply_push(force: Vector2) -> void:
	body.apply_central_impulse(force)
