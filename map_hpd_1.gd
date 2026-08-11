extends Node2D

@onready var dialogue_box = $DialogueBox

func _ready():
	dialogue_box.start([
		"<-->로 움직일 수 있어요",
		"A키로 공격해요"
	])
