extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label
@onready var label_timer: Timer = $LabelTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		label_timer.start()

func _on_timer_timeout() -> void:
	label.visible = true
