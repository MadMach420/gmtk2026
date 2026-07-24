extends Node2D
@export var foreground: CanvasItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		fade_foreground(0.5)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		fade_foreground(1.0) # Replace with function body.


func fade_foreground(target_alpha: float):
	var tween = create_tween()
	tween.tween_property(
		foreground,
		"modulate:a",
		target_alpha,
		0.5
	)
