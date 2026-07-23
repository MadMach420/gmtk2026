extends CharacterBody2D


const SPEED = 150.0
const PUSH_FORCE = 50

@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	resolve_collisions()


func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var box_body := collision.get_collider() as RigidBody2D

		if box_body:
			var box = box_body.get_parent() as ReversableBox
			if box:
				var push_direction = -collision.get_normal()
				box.apply_push(push_direction * PUSH_FORCE)
