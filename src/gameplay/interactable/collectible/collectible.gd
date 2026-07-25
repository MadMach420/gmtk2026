extends Area2D
class_name Collectible

signal on_map(collectible: Collectible)
signal picked_up(collectible: Collectible)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collectibles_system: CollectiblesSystem = Systems.get_node("%CollectiblesSystem")

func _ready() -> void:
	collectibles_system.register_collectible(self)
	on_map.emit(self)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		picked_up.emit(self)
		$CollisionShape2D.set_deferred("disabled", true)
		fade()


func fade():
	var tween = create_tween()
	tween.tween_property(
		sprite_2d,
		"modulate:a",
		0,
		0.5
	)


func _set_sprite_2d(_sprite_2d: Sprite2D) -> void:
	sprite_2d = _sprite_2d

func _remove_from_map(target: Collectible) -> void:
	if target == self:
		queue_free()
