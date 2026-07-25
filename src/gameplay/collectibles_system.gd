extends Node
class_name CollectiblesSystem

signal remove_from_map(collectible: Collectible)

var collected_items: Array[Collectible] = []


func register_collectible(collectible: Collectible):
	collectible.picked_up.connect(_on_picked_up)
	collectible.on_map.connect(_on_map)


func _on_picked_up(_collectible: Collectible) -> void:
	collected_items.append(_collectible)


func _on_map(_collectible: Collectible) -> void:
	if _collectible in collected_items:
		remove_from_map.emit()
