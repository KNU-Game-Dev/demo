class_name FlickerLight
extends PointLight2D

## PointLight2D 노드에 이 스크립트를 붙이면 랜덤하게 깜빡이는 조명이 됨

@export var min_energy: float = 0.3
@export var max_energy: float = 1.0
@export var flicker_speed_min: float = 0.05
@export var flicker_speed_max: float = 0.2

## 가끔 완전히 꺼졌다 켜지는 연출 (공포 분위기용)
@export var enable_blackout: bool = true
@export var blackout_chance: float = 0.05
@export var blackout_duration_min: float = 0.05
@export var blackout_duration_max: float = 0.3

var _base_energy: float


func _ready() -> void:
	_base_energy = energy
	_flicker_loop()


func _flicker_loop() -> void:
	while is_inside_tree():
		if enable_blackout and randf() < blackout_chance:
			energy = 0.0
			await get_tree().create_timer(
				randf_range(blackout_duration_min, blackout_duration_max)
			).timeout
		else:
			energy = randf_range(min_energy, max_energy)
			await get_tree().create_timer(
				randf_range(flicker_speed_min, flicker_speed_max)
			).timeout
