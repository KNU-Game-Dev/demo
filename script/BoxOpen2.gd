extends StaticBody2D

@onready var anim = $AnimatedSprite2D

var player_near := false
var opened := false

func _process(delta):
	if player_near and !opened and Input.is_action_just_pressed("interact"):
		opened = true
		anim.play("open2")

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		player_near = true

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		player_near = false
