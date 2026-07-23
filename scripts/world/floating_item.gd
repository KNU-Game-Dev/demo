extends Sprite2D
class_name FloatingItem

## [FloatingItem]
## 아이템이 위아래로 살짝 떠다니는 효과.
## 기존 ItemMove.gd에서 이 노드는 Sprite2D인데 자식 $AnimatedSprite2D를
## 참조하던 버그를 수정 (존재하지 않는 노드라 실행 시 오류가 났음).

@export var amplitude := 8.0      # 위아래 움직이는 거리
@export var speed := 3.0          # 움직이는 속도

var start_y := 0.0
var time := 0.0

func _ready():
	start_y = position.y

func _process(delta):
	time += delta
	position.y = start_y + sin(time * speed) * amplitude

	z_index = int(global_position.y + 16)
