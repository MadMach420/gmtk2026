extends Node2D

signal stomped

const SPEED = 30
const BOUNCE_FACTOR = 1.0

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var game_manager: Node2D = %GameManager

var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		sprite.flip_h = false
	
	position.x += direction * SPEED * delta


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	queue_free()


func _on_stompzone_entered(body: Node2D) -> void:
	if body.has_method("bounce"):
		body.bounce(BOUNCE_FACTOR)
		timer.start()
		sprite.play("hit")
		game_manager.add_points(10)
