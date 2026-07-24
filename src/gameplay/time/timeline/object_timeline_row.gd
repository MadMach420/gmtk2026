extends HBoxContainer
class_name ObjectTimelineRow

@onready var object_label: Label = $ObjectLabel
@onready var track: Control = $Track
@onready var playhead: ColorRect = $Track/PlayheadCursor

var reversable_object: ReversableObject
var loop_length: float

func setup(obj: ReversableObject, length: float) -> void:
	reversable_object = obj
	loop_length = length
	object_label.text = "Object"  # Replace with better name/icon
	
	# Connect to the object's live recording signal
	reversable_object.state_recorded.connect(_on_state_recorded)
	
	for snapshot in reversable_object.timeline:
		_add_indicator(snapshot["time"], snapshot["data"])
	
	playhead.visible = false

func _on_state_recorded(time_left: float, data: Dictionary) -> void:
	_add_indicator(time_left, data)

func _add_indicator(time_left: float, data: Dictionary) -> void:
	var indicator = preload("res://src/gameplay/time/timeline/TimelineIndicator.tscn").instantiate()
	track.add_child(indicator)
	indicator.setup(time_left, loop_length, data, reversable_object.object_color_code)

# Called by the main TimelineUI to move the rewind cursor
func update_playhead(current_time_left: float) -> void:
	var normalized_time = (loop_length - current_time_left) / loop_length
	playhead.position.x = normalized_time * track.size.x - playhead.size.x / 2
