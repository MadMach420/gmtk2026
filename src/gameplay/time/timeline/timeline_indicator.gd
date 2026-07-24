extends ColorRect
class_name TimelineIndicator


# Called by the ObjectTimelineRow to position the dot
func setup(time_left: float, loop_length: float, data: Dictionary, obj_color: Color) -> void:
	color = obj_color
	
	var normalized_time = (loop_length - time_left) / loop_length
	# Position horizontally based on parent track width
	position.x = normalized_time * get_parent_area_size().x - size.x / 2
