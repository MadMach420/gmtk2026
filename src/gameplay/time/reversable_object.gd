extends Node2D
class_name ReversableObject


@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")

# Example snapshot will look like: { "time": 45.2, "data": { "pos": Vector2(...) } }
var timeline: Array[Dictionary] = []
var is_rewinding: bool = false
# Only one tween per object allowed
var current_tween: Tween

var _was_snapshot_last_frame = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_system.loop_ended.connect(_start_rewind)


func _physics_process(delta: float) -> void:
	if is_rewinding:
		return
	
	var is_changing := _is_state_changing()
	if not is_changing:
		if _was_snapshot_last_frame:
			_record_state()
	if is_changing:
		if not _was_snapshot_last_frame and not timeline.is_empty():
				var snapshot = {
					"time": time_system.get_current_time_left() + delta,
					"data": timeline[-1]["data"]
				}
				timeline.append(snapshot)
		_record_state()
	_was_snapshot_last_frame = is_changing

# ------------------------------------------------
# --- VIRTUAL FUNCTIONS (Override in children) ---
# ------------------------------------------------
## Return true if the object's state has changed this frame
func _is_state_changing() -> bool:
	return false # Override this!

## Return a Dictionary containing all data needed to restore this object's state
func _get_state_data() -> Dictionary:
	return {"position": global_position} # Override this!

## Take a Dictionary of state data and apply it to the object
func _apply_state_data(data: Dictionary, duration: float) -> void:
	pass


# --------------------------------
# --- General reversable logic ---
# --------------------------------

func _record_state() -> void:
	var snapshot = {
		"time": time_system.get_current_time_left(),
		"data": _get_state_data()
	}
	timeline.append(snapshot)

## Start rewinding the object
func _start_rewind() -> void:
	_record_state()
		
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
