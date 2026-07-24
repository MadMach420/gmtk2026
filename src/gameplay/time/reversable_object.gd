extends Node2D
class_name ReversableObject


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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_system.loop_ended.connect(_start_rewind)


func _physics_process(delta: float) -> void:
	if is_rewinding:
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
				timeline.append({"time": current_time + delta, "data": timeline[-1]["data"]})
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
func _record_state() -> void:
	var snapshot = {
		"time": time_system.get_current_time_left(),
		"data": _get_state_data()
	}
	timeline.append(snapshot)
	
## Collapse consecutive "unchanged" snapshots into just their start/end points.
## Must run on the forward (not yet reversed) timeline.
func _compact_timeline() -> void:
	if timeline.size() < 3: # Edge case
		return
	
	var compacted: Array[Dictionary] = [timeline[0]]
	var run_start_idx = 0
	var run_last_idx = 0
	
	for i in range(1, timeline.size()):
		var delta_t = abs(timeline[i]["time"] - timeline[run_start_idx]["time"])
		if _states_equal(timeline[run_start_idx]["data"], timeline[i]["data"], delta_t):
			# still within the same static run - extend it, don't emit yet
			run_last_idx = i
		else:
			# run broke - emit its endpoint (if the run had more than one entry)
			if run_last_idx != run_start_idx:
				compacted.append({
					"time": timeline[i-1]["time"],
					"data": compacted[-1]["data"]
				})
			compacted.append(timeline[i])
			run_start_idx = i
			run_last_idx = i
	
	# flush a trailing run that reached the end of the timeline
	if run_last_idx != run_start_idx:
		compacted.append({
					"time": timeline[run_last_idx]["time"],
					"data": compacted[-1]["data"]
				})
	
	timeline = compacted

## Start rewinding the object
func _start_rewind() -> void:
	_record_state()
	_compact_timeline()
		
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
