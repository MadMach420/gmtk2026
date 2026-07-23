extends ReversableObject
class_name ReversableBox

@onready var body: RigidBody2D = $RigidBody2D

var last_recorded_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready() 
	last_recorded_position = body.global_position
	

func _is_state_changing() -> bool:
	var distance = body.global_position.distance_to(last_recorded_position)
	if distance > 5.0: # Snapshot every time the box moves >5 pixels
		last_recorded_position = body.global_position
		return true
	return false

func _get_state_data() -> Dictionary:
	return {
		"position": body.global_position,
		"rotation": body.global_rotation,
	}

func _apply_state_data(data: Dictionary) -> void:
	# Manually force the RigidBody into the recorded position
	body.global_position = data["position"]
	body.global_rotation = data["rotation"]
	
	# Zero out velocity and let tween handle movement
	body.linear_velocity = Vector2.ZERO
	body.angular_velocity = 0.0
	body.sleeping = false 


func apply_push(force: Vector2) -> void:
	body.apply_central_impulse(force)
