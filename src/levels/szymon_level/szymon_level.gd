extends Level

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var reversable_button: ReversableButton = $Entities/ReversableButton
@onready var gate: StaticBody2D = $Entities/Gate
@onready var soundtrack_system: SoundtrackSystem = Systems.get_node("%SoundtrackSystem")

func _ready() -> void:
	super._ready()
	reversable_button.toggled.connect(func(is_pressed: bool): gate.open() if is_pressed else gate.close())

func _process(delta: float) -> void:
	super._process(delta)


## This mus be implemented by Level's child, because Level doesn't hold any nodes by default
func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()
		soundtrack_system._set_normal()
