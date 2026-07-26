extends ReversableObject

@export var button: ReversableButton
@export var animation_player: AnimationPlayer

func _ready() -> void:
	super._ready()
	button.toggled.connect(_on_button_toggled)
	time_system.loop_ended.connect(_on_loop_ended)

func _on_loop_ended(delta: float) -> void:
	animation_player.pause()

func get_texture() -> Texture2D:
	var frame_index: int = animation_player.get_frame()
	var animation_name: String = animation_player.animation
	var sprite_frames: SpriteFrames = animation_player.get_sprite_frames()
	var current_texture: Texture2D = sprite_frames.get_frame_texture(animation_name, frame_index)
	return current_texture

func _start_rewind() -> void:
	super._start_rewind()

func _on_button_toggled(is_pressed: bool) -> void:
	if self.time_system.has_loop_started and not self.time_system.has_loop_ended:
		if is_pressed:
			animation_player.play("move")
		else:
			animation_player.pause()
	elif self.time_system.is_rewinding:
		if is_pressed:
			animation_player.play_backwards("move")
		else:
			animation_player.pause()
