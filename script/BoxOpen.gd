extends StaticBody2D

@onready var anim = $AnimatedSprite2D

var opened := false

func _ready():
	anim.animation_finished.connect(_on_animation_finished)

func _input(event):
	if event.is_action_pressed("interact") and !opened:
		opened = true
		anim.play("open")

func _on_animation_finished():
	if anim.animation == "open":
		anim.stop()
		anim.frame = anim.sprite_frames.get_frame_count("open") - 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
