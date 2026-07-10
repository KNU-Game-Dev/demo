extends Sprite2D

@export var amplitude := 8.0      # 위아래 움직이는 거리
@export var speed := 3.0          # 움직이는 속도

var start_y := 0.0
var time := 0.0

func _ready():
	start_y = position.y

func _process(delta):
	time += delta
	position.y = start_y + sin(time * speed) * amplitude

	z_index = int($AnimatedSprite2D.global_position.y + 16)
