extends Node2D

@export var max_speed: float = 100

@export var acceleration: float = 4
@export var deceleration: float = 10
@export var direction_change_acceleration: float = 12


func get_horizontal_velocity(velocity: float, direction: float, delta: float) -> float:
	"""
	Calculates horizontal velocity.
	"""
	var target_speed = max_speed * direction
	var acceleration = get_acceleration(direction, velocity)
	
	velocity = lerp(velocity, target_speed, delta * acceleration)
	return velocity
	
func get_acceleration(direction: float, velocity: float) -> float:
	"""
	Get acceleration value.
	"""
	if direction != 0:
		if are_opposite(direction, velocity):
			return direction_change_acceleration
		else:
			return acceleration
	else:
		return deceleration

func are_opposite(a: float, b: float, eps: float = 0.001) -> bool:
	"""
	Checks if values have opposite signs (opposite directions).
	"""
	if abs(a) < eps or abs(b) < eps:
		return false
	
	return sign(a) != sign(b)
