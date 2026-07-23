# Schizophrenia.gd
extends Node2D

enum ViewMode { A_ONLY, B_ONLY, BOTH }
var current_mode = ViewMode.BOTH

@onready var container_a = $UILayer/ContainerA
@onready var container_b = $UILayer/ContainerB
@onready var player_a = $UILayer/ContainerA/ViewportA/WorldA/Player
@onready var player_b = $UILayer/ContainerB/ViewportB/WorldB/Player
# 시점 변경
func set_view_mode(mode: ViewMode):
	current_mode = mode
	match mode:
		ViewMode.A_ONLY:
			container_a.visible = true
			container_a.modulate.a = 1.0
			container_b.visible = false
			_set_player_active(player_a, true)
			_set_player_active(player_b, false)
		ViewMode.B_ONLY:
			container_a.visible = false
			container_b.visible = true
			container_b.modulate.a = 1.0
			_set_player_active(player_a, false)
			_set_player_active(player_b, true)
		ViewMode.BOTH:
			container_a.visible = true
			container_b.visible = true
			container_a.modulate.a = 1.0
			container_b.modulate.a = 0.6  # 겹침 효과
			_set_player_active(player_a, true)
			_set_player_active(player_b, true)
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
			
# 플레이어 껏다 키기
func _set_player_active(player: Node, active: bool):
	player.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED


func _update_dialogue(mode: ViewMode):
	match mode:
		ViewMode.A_ONLY:
			print("A월드 토글")  
		ViewMode.B_ONLY:
			print("B월드 토글")
		ViewMode.BOTH:
			print("C월드 토글")
