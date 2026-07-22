extends Node

func handle_input(event):
	if event.is_action_pressed("attack"):
		attack()

func attack():
	print("공격")
