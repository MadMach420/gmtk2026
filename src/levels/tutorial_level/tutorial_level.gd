extends Level

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var reversable_button: ReversableButton = $Entities/ReversableButton
@onready var reversable_lever: ReversableLever = $Entities/ReversableLever
@onready var tutorial_hud: Node2D = $TutorialHud


func _ready() -> void:
	super._ready()
		

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("start_loop"):
		if tutorial_hud: tutorial_hud.queue_free()


## This mus be implemented by Level's child, because Level doesn't hold any nodes by default
func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()
