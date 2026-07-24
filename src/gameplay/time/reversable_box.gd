extends ReversableObject
class_name ReversableBox

@onready var body: RigidBody2D = $RigidBody2D

@export var position_epsilon: float = 2   # pixels
@export var speed_epsilon: float = 2.0   # pixels per second
@export var angular_speed_epsilon: float = 0.1  # radians per second

var last_recorded_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_record_state()
	last_recorded_position = body.global_position


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

func _states_equal(a: Dictionary, b: Dictionary, delta_t: float = EPSILON_T) -> bool:
	if a.is_empty() or b.is_empty():
		return a == b
	var dist = a["position"].distance_to(b["position"])
	if dist < position_epsilon:
		return true  # too small to matter, regardless of delta_t
	delta_t = max(delta_t, 0.001)
	var speed = dist / delta_t
	var angular_speed = abs(angle_difference(a["rotation"], b["rotation"])) / delta_t
	return speed < speed_epsilon and angular_speed < angular_speed_epsilon

func _is_at_rest() -> bool:
	return body.sleeping

func apply_push(force: Vector2) -> void:
	body.apply_central_impulse(force)

# -----------------------
# Override with super call
func _start_rewind() -> void:
	super._start_rewind()
	_print_states()


# -----------------------
# Temp helper
func _print_states() -> void:
	var previous_state: Dictionary = {"time": 0, "data": {}}
	for i in timeline:
		var delta_t = abs(i["time"] - previous_state["time"])
		if delta_t > EPSILON_T and _states_equal(previous_state["data"], i["data"], delta_t):
			print("Unchanging state detected: ")
			print("  Time start: {time}".format({"time": previous_state["time"]}))
			print("  Time stop: {time}".format({"time": i["time"]}))
			print("  Delta t: {0}".format([delta_t]))
			print("  Position1: {pos}".format({"pos": previous_state["data"]}))
			print("  Position2: {pos}".format({"pos": i["data"]}))
		previous_state = i
		
