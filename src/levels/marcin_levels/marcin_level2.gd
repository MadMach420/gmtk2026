extends Level

@onready var next_level_trigger: Area2D = $NextLevelTrigger
@onready var reversable_button1: ReversableButton = $Entities/ReversableButton1
@onready var reversable_button2: ReversableButton = $Entities/ReversableButton2
@onready var reversable_button3: ReversableButton = $Entities/ReversableButton3
@onready var reversable_lever: ReversableLever = $Entities/ReversableLever
@onready var reversable_lever_2: ReversableLever = $Entities/ReversableLever2

@onready var platform: AnimatableBody2D = $Entities/Platform
@onready var platform_2: AnimatableBody2D = $Entities/Platform2
@onready var gate1: StaticBody2D = $Entities/Gate1
@onready var gate2: StaticBody2D = $Entities/Gate2
@onready var gate3: StaticBody2D = $Entities/Gate3


func _ready() -> void:
	super._ready()
	reversable_button1.toggled.connect(func(is_pressed: bool): gate1.open() if is_pressed else gate1.close())
	reversable_button2.toggled.connect(func(is_pressed: bool): gate2.open() if is_pressed else gate2.close())
	reversable_button3.toggled.connect(func(is_pressed: bool): gate3.open() if is_pressed else gate3.close())

	
	reversable_lever.toggled.connect(func(is_pressed: bool): platform.extend_platform() if is_pressed else platform.retract_platform())
	reversable_lever_2.toggled.connect(func(is_pressed: bool): platform_2.extend_platform() if is_pressed else platform_2.retract_platform())


func _process(delta: float) -> void:
	super._process(delta)

func _on_next_level_trigger_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered_transition_zone.emit()
