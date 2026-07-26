extends Level

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var tutorial_text: Label = $TutorialHud/Label
@onready var reversable_button: ReversableButton = $Entities/ReversableButton
@onready var platform: AnimatableBody2D = $Entities/Platform

@onready var soundtrack_system: SoundtrackSystem = Systems.get_node("%SoundtrackSystem")

var tutorial_prompt_index: int = 0

func _ready() -> void:
	super._ready()
	time_system.loop_started.connect(_clear_tutorial_text)
	time_system.loop_ended.connect(_on_loop_ended)
	time_system.rewind_started.connect(_clear_tutorial_text)
	reversable_button.toggled.connect(func(is_pressed: bool): platform.extend_platform() if is_pressed else platform.retract_platform())
	

func _clear_tutorial_text() -> void:
	tutorial_text.text= ""

func _on_loop_ended() -> void:
	tutorial_text.text= "SPACE to rewind"

## This mus be implemented by Level's child, because Level doesn't hold any nodes by default
func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()
		soundtrack_system._set_normal()
