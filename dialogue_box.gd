extends CanvasLayer

signal finished

@onready var label = $Panel/Label

var lines: Array = []
var current_index := 0


func start(text_lines: Array):
	lines = text_lines
	current_index = 0
	visible = true
	show_line()


func show_line():
	label.text = lines[current_index]


func _unhandled_input(event):
	if not visible:
		return
	if event.is_action_pressed("interact"):
		advance()


func advance():
	current_index += 1
	if current_index >= lines.size():
		close()
	else:
		show_line()


func close():
	visible = false
	emit_signal("finished")
