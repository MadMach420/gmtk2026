extends Level

@export var gate: StaticBody2D
@export var lever: ReversableLever

@onready var soundtrack_system: SoundtrackSystem = Systems.get_node("%SoundtrackSystem")

func _ready() -> void:
	super._ready()
	gate.open()
	lever.toggled.connect(func(is_pressed: bool): gate.open() if not is_pressed else gate.close())



func _process(delta: float) -> void:
	super._process(delta)


func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()
		soundtrack_system._set_normal()
