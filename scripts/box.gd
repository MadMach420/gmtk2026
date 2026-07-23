class_name MovableObject
extends CharacterBody2D

@onready var game_manager: Node2D = %GameManager
@export_range(0.0, 1.0) var impact_response := 0.5
@export var friction = 90.0

# zmienna do robienia snapshotow w czasie, zeby pozniej cofnac akcje wykonane w tym czasie idk juz co pisze
var physics_process_tick: int = 0
var reverse_physics_process_tick: int = 0
var current_snapshot_index: int = 0
var reverse_time: float = 0
const SNAPSHOT_TICK_INTERVAL = 12
const PHYSICS_PROCESS_TICKS_PER_SECOND: int = 60
const PHYSICS_TICKS_PER_SNAPSHOT = PHYSICS_PROCESS_TICKS_PER_SECOND / SNAPSHOT_TICK_INTERVAL

var position_snapshots: Array[Vector2] = []

func apply_impact(impact_velocity: Vector2) -> void:
	velocity += (impact_velocity - velocity) * impact_response
	
func save_position_snapshot() -> void:
	position_snapshots.push_front(position)
	
func regular_time_physics_process(delta: float) -> void:
	velocity.y = velocity.y + delta * get_gravity().y
	
	if velocity.x > 0:
		velocity.x = velocity.x - (friction * delta)
	elif velocity.x < 0:
		velocity.x = velocity.x + (friction * delta)
		
	if velocity.abs().x < 10:
		velocity.x = 0
	
	move_and_slide()
	
	if physics_process_tick % SNAPSHOT_TICK_INTERVAL == 0:
		save_position_snapshot()
	
	physics_process_tick += 1

func reversed_time_physics_process(delta: float) -> void:
	velocity = Vector2(0, 0)
	
	var reverse_time_delta := delta * (1 / (PHYSICS_TICKS_PER_SNAPSHOT * delta))
	reverse_time += reverse_time_delta
	
	if reverse_time > 1:
		reverse_time = 0
		current_snapshot_index += 1
	
	if current_snapshot_index < len(position_snapshots) - 1:
		position = position.lerp(position_snapshots[current_snapshot_index], reverse_time)


func _physics_process(delta: float) -> void:
	if game_manager.reverse_time == false:
		regular_time_physics_process(delta)
	else:
		reversed_time_physics_process(delta)
