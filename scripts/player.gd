extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 400.0 
const DASH_DURATION = 0.2 # Shortened dash duration to 0.25s

var last_direction_pressed: String = ""
var is_dashing: bool = false
var dash_direction: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var double_tap_timer: Timer = $Timer

func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		
		if body:
			body.apply_impact(-100.0 * collision.get_normal())

func _physics_process(delta: float) -> void:
	# 1. GRAVITY: Disable gravity completely while dashing
	if not is_on_floor() and not is_dashing:
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dashing:
		velocity.y = JUMP_VELOCITY

	# Get standard input direction
	var direction := Input.get_axis("move_left", "move_right")
	
	# Sprite flipping
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	# Animations
	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
	else:
		sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if move_and_slide():
		resolve_collisions()
