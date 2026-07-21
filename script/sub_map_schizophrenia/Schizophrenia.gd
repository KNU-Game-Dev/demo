# Schizophrenia.gd
extends Node2D

enum ViewMode { A_ONLY, B_ONLY, BOTH }
var current_mode = ViewMode.BOTH

@onready var container_a = $UILayer/ContainerA
@onready var container_b = $UILayer/ContainerB

# 시점 변경
func set_view_mode(mode: ViewMode):
	current_mode = mode
	match mode:
		ViewMode.A_ONLY:
			container_a.visible = true
			container_a.modulate.a = 1.0
			container_b.visible = false
		ViewMode.B_ONLY:
			container_a.visible = false
			container_b.visible = true
			container_b.modulate.a = 1.0
		ViewMode.BOTH:
			container_a.visible = true
			container_b.visible = true
			container_a.modulate.a = 1.0
			container_b.modulate.a = 0.6  # 겹침 효과
	_update_dialogue(mode)
	
func _input(event):
	if event.is_action_pressed("toggle_view"):
		_cycle_view_mode()

func _cycle_view_mode():
	match current_mode:
		ViewMode.A_ONLY:
			set_view_mode(ViewMode.B_ONLY)
		ViewMode.B_ONLY:
			set_view_mode(ViewMode.BOTH)
		ViewMode.BOTH:
			set_view_mode(ViewMode.A_ONLY)

func _update_dialogue(mode: ViewMode):
	match mode:
		ViewMode.A_ONLY:
			print("A월드 토글")  
		ViewMode.B_ONLY:
			print("B월드 토글")
		ViewMode.BOTH:
			print("C월드 토글")
