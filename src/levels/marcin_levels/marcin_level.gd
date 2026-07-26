extends Level

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var reversable_button1: ReversableButton = $Entities/ReversableButton1
@onready var reversable_button2: ReversableButton = $Entities/ReversableButton2
@onready var reversable_button3: ReversableButton = $Entities/ReversableButton3

@onready var gate1: StaticBody2D = $Entities/Gate1
@onready var gate2: StaticBody2D = $Entities/Gate2
@onready var gate3: StaticBody2D = $Entities/Gate3


func _ready() -> void:
	super._ready()
	reversable_button1.toggled.connect(func(is_pressed: bool): gate1.open() if is_pressed else gate1.close())
	reversable_button2.toggled.connect(func(is_pressed: bool): gate2.open() if is_pressed else gate2.close())
	reversable_button3.toggled.connect(func(is_pressed: bool): gate3.open() if is_pressed else gate3.close())

func _process(delta: float) -> void:
	super._process(delta)


## This mus be implemented by Level's child, because Level doesn't hold any nodes by default
func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_entered_transition_zone.emit()
