extends ReversableObject
class_name ReversableButton

signal toggled(is_pressed: bool)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	animated_sprite_2d.modulate = object_color_code

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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if time_system.is_rewinding: return
	if body is CharacterBody2D or body is RigidBody2D:
		toggled.emit(true)
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if time_system.is_rewinding: return
	if body is CharacterBody2D or body is RigidBody2D:
		toggled.emit(false)

func _on_toggled(is_pressed: bool) -> void:
	self.is_pressed = is_pressed
	
	if self.is_pressed:
		animated_sprite_2d.play("pressed")
	else:
		animated_sprite_2d.play("released")
