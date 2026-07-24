extends Node2D
class_name ReversableObject

signal state_recorded


@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")

## Constant used for checking for state changes
const EPSILON_T = 0.08

# Example snapshot will look like: { "time": 45.2, "data": { "pos": Vector2(...) } }
var timeline: Array[Dictionary] = []
var is_rewinding: bool = false
# Only one tween per object allowed
var current_tween: Tween

var _has_changed_last_frame = false
var _was_at_rest_last_frame: bool = false
var _previous_snapshot = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_system.rewind_started.connect(_start_rewind)
	time_system.loop_started.connect(_record_state)
	time_system.loop_ended.connect(_record_state)
	time_system.reversable_object_registry.register_object(self)


func _physics_process(delta: float) -> void:
	if is_rewinding or time_system.loop_timer.is_stopped():
		return
	
	var current_time = time_system.get_current_time_left()
	var delta_t = abs((timeline[-1]["time"] if not timeline.is_empty() else INF) - current_time)
	var is_at_rest = _is_at_rest()
	
	# Just fell asleep this frame -- record the settle point before going quiet.
	if is_at_rest and not _was_at_rest_last_frame and delta_t > EPSILON_T:
		_record_state()
		_has_changed_last_frame = false
		_was_at_rest_last_frame = is_at_rest
		return
	_was_at_rest_last_frame = is_at_rest
	
	if delta_t > EPSILON_T:
		var current_data = _get_state_data()
		var last_data = {} if timeline.is_empty() else timeline[-1]["data"]
		var has_state_changed = not is_at_rest and not _states_equal(last_data, current_data, delta_t)
		
		if has_state_changed:
			if not _has_changed_last_frame and not timeline.is_empty():
				_append_to_timeline({"time": current_time + delta, "data": timeline[-1]["data"]})
			_record_state()
		elif _has_changed_last_frame:
			_record_state()
			
		_has_changed_last_frame = has_state_changed

# ------------------------------------------------
# --- VIRTUAL FUNCTIONS (Override in children) ---
# ------------------------------------------------
## Virtual: return a Dictionary containing all data needed to restore this object's state
func _get_state_data() -> Dictionary:
	return {"position": global_position}

## Virtual: take a Dictionary of state data and apply it to the object
func _apply_state_data(data: Dictionary, duration: float) -> void:
	pass

## Virtual: override to define "close enough" per-object.
## Default: exact equality (fine for non-physics data).
func _states_equal(a: Dictionary, b: Dictionary, delta_t: float = EPSILON_T) -> bool:
	return a == b

## Virtual: override for a cheap "definitely at rest" check (e.g. RigidBody2D.sleeping).
## Default: no shortcut available.
func _is_at_rest() -> bool:
	return false


# --------------------------------
# --- General reversable logic ---
# --------------------------------
func get_timeline() -> Array[Dictionary]:
	return timeline

func _record_state() -> void:
	var snapshot = {
		"time": time_system.get_current_time_left(),
		"data": _get_state_data()
	}
	_append_to_timeline(snapshot)
	
func _append_to_timeline(snapshot: Dictionary):
	if timeline.is_empty():
		timeline.append(snapshot)
		state_recorded.emit(timeline[-1]["time"], timeline[-1]["data"])
	else:
		var delta_t = abs(timeline[-1]["time"] - snapshot["time"])
		if _states_equal(timeline[-1]["data"], snapshot["data"], delta_t):
			# If current snapshot state is the same as last, skip it
			pass
		else:
			var previous_delta = abs(timeline[-1]["time"] - _previous_snapshot["time"])
			if _states_equal(timeline[-1]["data"], _previous_snapshot["data"], previous_delta):
				timeline.append({
					"time": _previous_snapshot["time"],
					"data": timeline[-1]["data"]
				})
				state_recorded.emit(timeline[-1]["time"], timeline[-1]["data"])
			timeline.append(snapshot)
			state_recorded.emit(timeline[-1]["time"], timeline[-1]["data"])

	if snapshot["time"] == 0.0:
		timeline.append({
			"time": snapshot["time"],
			"data": timeline[-1]["data"]
		})
	
	_previous_snapshot = snapshot


## Start rewinding the object
func _start_rewind() -> void:	
	_record_state()
	#print(timeline)
	#print(len(timeline))
	#_compact_timeline()
	#print(len(timeline))
		
	is_rewinding = true
	
	# Stop normal processing/physics for this object during rewind
	set_process(false)
	set_physics_process(false)
	if has_node("RigidBody2D"):
		get_node("RigidBody2D").freeze = true
	
	# Reverse the timeline so the newest state is first, oldest is last
	timeline.reverse()
	
	current_tween = create_tween()
	current_tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	
	# Play through the reversed timeline
	for i in range(1, timeline.size()):
		var snapshot = timeline[i]
		var duration = 0.0
		
		# Calculate how long this specific state lasted originally
		var previous_snapshot_time = timeline[i - 1]["time"]
		duration = snapshot["time"] - previous_snapshot_time

		if duration > 0:
			_apply_state_data(snapshot["data"], duration)
			
	# When the tween finishes, reset the object
	current_tween.tween_callback(_on_rewind_finished)

## Rewind finished callback - reset object
func _on_rewind_finished() -> void:
	timeline.clear()
	is_rewinding = false
	set_process(true)
	set_physics_process(true)
