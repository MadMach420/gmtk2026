extends ReversableObject
class_name ReversableButton

signal toggled(is_pressed: bool)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _get_state_data() -> Dictionary:
	return {
		"is_pressed": is_pressed
	}


func _apply_state_data(data: Dictionary, duration: float) -> void:
	current_tween.tween_interval(duration)
	current_tween.tween_callback(func(): toggled.emit(data.get("is_pressed")))

func _is_at_rest() -> bool:
	return false

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
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D or body is RigidBody2D:
		toggled.emit(true)
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D or body is RigidBody2D:
		toggled.emit(false)

func _on_toggled(is_pressed: bool) -> void:
	self.is_pressed = is_pressed
	
	if self.is_pressed:
		animated_sprite_2d.play("pressed")
	else:
		animated_sprite_2d.play("released")
