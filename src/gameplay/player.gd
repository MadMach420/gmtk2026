extends CharacterBody2D

## Has the player pressed the interact action to start the level timer? (Loop or rewind)
var has_started_timer = false

const SPEED = 100.0
const PUSH_FORCE = 50

const STEP_JUMP_VELOCITY := -80

@onready var upper_raycaster_right: RayCast2D = $Raycasters/UpperRaycasterRight      
@onready var upper_raycaster_left: RayCast2D = $Raycasters/UpperRaycasterLeft
@onready var lower_raycaster_right: RayCast2D = $Raycasters/LowerRaycasterRight
@onready var lower_raycaster_left: RayCast2D = $Raycasters/LowerRaycasterLeft

@export var use_legacy_movement: bool = false
@onready var player_collision_shape: CollisionShape2D = $CollisionShape2D

var previous_velocity: float = 0.0  # stores pre-collision velocity

@onready var time_system: TimeSystem = Systems.get_node("TimeSystem")
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_movement: Node2D = $PlayerMovement


func _ready() -> void:
	time_system.loop_started.connect(func(): has_started_timer = true)
	time_system.loop_ended.connect(func(): has_started_timer = false)
	time_system.rewind_started.connect(func(): has_started_timer = true)
	time_system.rewind_ended.connect(func(): has_started_timer = false)

func _physics_process(delta: float) -> void:
	if not has_started_timer:
		if Input.is_action_just_pressed("interact"):
			has_started_timer = true
			time_system.start_timer()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if has_started_timer:
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			sprite_2d.flip_h = false
		elif direction < 0:
			sprite_2d.flip_h = true
		
		if  use_legacy_movement:
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = player_movement.get_horizontal_velocity(velocity.x, direction, delta)
	else:
		velocity.x = 0
	
	previous_velocity = velocity.x
	
	handle_step_jump()
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
				velocity.x = previous_velocity

func handle_step_jump() -> void:
	if !is_on_floor():
		return

	if velocity.y < 0:
		return

	if  velocity.x > 0:
		if lower_raycaster_right.is_colliding() and !upper_raycaster_right.is_colliding() and !lower_raycaster_left.is_colliding():
			velocity.y = STEP_JUMP_VELOCITY

	elif velocity.x < 0:
		if lower_raycaster_left.is_colliding() and !upper_raycaster_left.is_colliding() and !lower_raycaster_right.is_colliding():
			velocity.y = STEP_JUMP_VELOCITY
