# 표지판 Area2D 스크립트
extends Area2D

var player_inside = false

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		player_inside = true

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		player_inside = false

func _input(event):
	if player_inside and event.is_action_pressed("interact"):
		get_node("/root/Room1_tscn").can_toggle = true  # Schizophrenia 노드 경로
		get_node("/root/Room1_tscn/UILayer/CanvasLayer/TextureRect/slide_down").play("slide_down")
		get_node("/root/Room1_tscn/UILayer/CanvasLayer/TextureRect/Label").text = "R 키를 눌러 대화 \"나\"와
 대화하시오."
		print("망고")
		# UI 숨기기
