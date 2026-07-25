extends Level

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var tutorial_hud: CanvasLayer = $TutorialHud
@onready var tutorial_text: Label = $TutorialHud/Label

const TUTORIAL_PROMPTS: Array[String] = [
"""You are one very tired vampire
You need to get to bed fast!
But there is a time anomaly stopping you
Try to get to the bottom of the level before the time runs out

[E]""",

"""Use A/D or Left/Right to move
Use E to interact
Use SPACE to start the time loop
Hold R to restart a level

[E]"""
]

var tutorial_prompt_index: int = 0

func _ready() -> void:
	super._ready()
	tutorial_text.text = TUTORIAL_PROMPTS[tutorial_prompt_index]

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("start_loop"):
		if tutorial_hud: tutorial_hud.queue_free()
	
	if Input.is_action_just_pressed("interact"):
		tutorial_prompt_index += 1
		if tutorial_prompt_index < len(TUTORIAL_PROMPTS):
			tutorial_text.text = TUTORIAL_PROMPTS[tutorial_prompt_index]
		else:
			tutorial_hud.queue_free()


## This mus be implemented by Level's child, because Level doesn't hold any nodes by default
func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()
