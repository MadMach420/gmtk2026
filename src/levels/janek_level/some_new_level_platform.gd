extends Level

@onready var soundtrack_system: SoundtrackSystem = Systems.get_node("%SoundtrackSystem")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()
		soundtrack_system._set_normal()
