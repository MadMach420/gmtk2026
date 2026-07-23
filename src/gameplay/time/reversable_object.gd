extends Node2D
class_name ReversableObject


@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")

# Example snapshot will look like: { "time": 45.2, "data": { "pos": Vector2(...) } }
var timeline: Array[Dictionary] = []
var is_rewinding: bool = false
# Only one tween per object allowed
var current_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_system.loop_ended.connect(_start_rewind)
	time_system.loop_started.connect(_on_loop_started)
	
	# Record the absolute initial state
	_record_state()


func _physics_process(delta: float) -> void:
	if _is_state_changing():
		_record_state()

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
func _apply_state_data(data: Dictionary) -> void:
	global_position = data.get("position", global_position) # Override this!


# --------------------------------
# --- General reversable logic ---
# ---------------------------- ---

func _record_state() -> void:
	var snapshot = {
		"time": time_system.get_current_time_left(),
		"data": _get_state_data()
	}
	timeline.append(snapshot)

func _on_loop_started() -> void:
	# Record state on loop start
	_record_state()

## Start rewinding the object
func _start_rewind() -> void:
	print(timeline)
	
	is_rewinding = true
	
	# Stop normal processing/physics for this object during rewind
	set_process(false)
	set_physics_process(false)
	
	# Reverse the timeline so the newest state is first, oldest is last
	timeline.reverse()
	
	current_tween = create_tween()
	current_tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	
	# Play through the reversed timeline
	for i in range(timeline.size()):
		var snapshot = timeline[i]
		var duration = 0.0
		
		# Calculate how long this specific state lasted originally
		if i < timeline.size() - 1:
			var next_snapshot_time = timeline[i + 1]["time"]
			duration = snapshot["time"] - next_snapshot_time
			
		# Apply the state instantly
		current_tween.tween_callback(_apply_state_data.bind(snapshot["data"]))
		
		# Wait for the duration that passed between this state and the next
		if duration > 0:
			current_tween.tween_interval(duration)
			
	# When the tween finishes, reset the object
	current_tween.tween_callback(_on_rewind_finished)

## Rewind finished callback - reset object
func _on_rewind_finished() -> void:
	timeline.clear()
	is_rewinding = false
	set_process(true)
	set_physics_process(true)
