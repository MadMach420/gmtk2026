extends ReversableObject
class_name ReversableLever

# toggles the lever between current state and the oposite state (on/off)
signal toggled(is_on: bool)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_on = false
var player_on_lever = false

func _process(delta: float) -> void:
	if player_on_lever and Input.is_action_just_pressed("interact"):
		toggled.emit(!is_on)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _get_state_data() -> Dictionary:
	return {
		"is_on": is_on
	}


func _apply_state_data(data: Dictionary, duration: float) -> void:
	current_tween.tween_interval(duration)
	current_tween.tween_callback(func(): toggled.emit(data.get("is_on")))

func _is_at_rest() -> bool:
	return false

# -----------------------
# Override with super call
func _start_rewind() -> void:
	super._start_rewind()

func _on_toggled(is_on: bool) -> void:
	self.is_on = is_on
	 
	if self.is_on:
		animated_sprite_2d.play("left")
	else:
		animated_sprite_2d.play("right")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_on_lever = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_on_lever = false
