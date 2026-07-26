extends Node

class_name SoundtrackSystem

@export var normal_volume_db := -10.0
@export var muted_volume_db := -80.0
@export var fade_time := 1.0

@onready var time_system: TimeSystem = Systems.get_node("%TimeSystem")
@onready var track1: AudioStreamPlayer = $ThemePlayer
@onready var track2: AudioStreamPlayer = $LevelMusicPlayer
@onready var track3: AudioStreamPlayer = $LevelMusicReversePlayer


func _ready() -> void:
	track1.play()

	track2.stop()
	track2.volume_db = muted_volume_db

	time_system.loop_started.connect(_set_action)
	time_system.loop_ended.connect(_set_normal)
	time_system.rewind_started.connect(_set_action_reverse)
	time_system.rewind_ended.connect(_set_normal)


func _set_action() -> void:
	track2.pitch_scale = 1.0

	if not track2.playing:
		track2.play(0.37)

	var tween := create_tween()

	tween.parallel().tween_property(
		track1,
		"volume_db",
		muted_volume_db,
		fade_time
	)

	track2.volume_db = normal_volume_db


func _set_normal() -> void:
	var tween := create_tween()

	tween.parallel().tween_property(
		track1,
		"volume_db",
		normal_volume_db,
		fade_time
	)

	tween.parallel().tween_property(
		track2,
		"volume_db",
		muted_volume_db,
		fade_time
	)

	await tween.finished

	track2.stop()
	track3.stop()


func _set_action_reverse() -> void:
	track3.play(4.37)

	var tween := create_tween()

	tween.parallel().tween_property(
		track1,
		"volume_db",
		muted_volume_db,
		fade_time
	)

	track3.volume_db = normal_volume_db


func set_menu_volume() -> void:
	track1.volume_db = 0
