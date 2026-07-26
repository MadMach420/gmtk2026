extends CanvasLayer
class_name Timeline

@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")
@onready var timeline_container: VBoxContainer = $MarginContainer/TimelineContainer

var object_rows: Dictionary[ReversableObject, ObjectTimelineRow] = {}


func _ready() -> void:
	# Listen for new objects registering
	time_system.reversable_object_registry.object_registered.connect(_create_row)
	
	# Listen for time loop phases
	time_system.rewind_started.connect(_on_rewind_started)
	time_system.rewind_ended.connect(_on_rewind_ended)
	time_system.loop_started.connect(_on_loop_started)
	
	# Register objects that might have loaded before the UI
	#for obj in time_system.reversable_object_registry.registered_reversable_objects:
		#_create_row(obj)

func _process(delta: float) -> void:
	# If rewinding, update all playhead cursors
	if time_system.is_rewinding:
		var current_time = time_system.get_current_time_left()
		for row in object_rows.values():
			row.update_playhead(current_time)

func _create_row(obj: ReversableObject) -> void:
	if object_rows.has(obj):
		return
	
	var row_scene = preload("res://src/gameplay/time/timeline/ObjectTimelineRow.tscn").instantiate()
	timeline_container.add_child(row_scene)
	row_scene.setup(obj, time_system.loop_length_s)
	object_rows[obj] = row_scene

func _on_rewind_started() -> void:
	for row in object_rows.values():
		row.playhead.visible = true

func _on_rewind_ended() -> void:
	for row in object_rows.values():
		row.playhead.visible = false

func _on_loop_started() -> void:
	for row in object_rows.values():
		for child in row.track.get_children():
			if child is TimelineIndicator:
				child.queue_free()
		row.playhead.visible = false
