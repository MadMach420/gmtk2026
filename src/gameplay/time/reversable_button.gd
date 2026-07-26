extends ReversableObject
class_name ReversableButton

signal toggled(is_pressed: bool)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
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

func get_texture() -> Texture2D:
	var frame_index: int = animated_sprite_2d.get_frame()
	var animation_name: String = animated_sprite_2d.animation
	var sprite_frames: SpriteFrames = animated_sprite_2d.get_sprite_frames()
	var current_texture: Texture2D = sprite_frames.get_frame_texture(animation_name, frame_index)
	return current_texture

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
		animation_player.play("press")
	else:
		animation_player.play("release")
