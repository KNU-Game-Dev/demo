# exit.gd
extends Area2D

@export var next_scene: String = "res://scenes/maps/room2.tscn"

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		get_tree().change_scene_to_file(next_scene)
