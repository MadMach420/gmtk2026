extends Node
class_name ReversableObjectRegistry


signal object_registered

# An array with all reversable objects in the level
var registered_reversable_objects: Array[ReversableObject] = []


func register_object(object: ReversableObject) -> void:
	registered_reversable_objects.append(object)
	object_registered.emit(object)
