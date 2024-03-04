extends CanvasLayer

var wave_string : String = "Wave "
var wave : int = 0
var show_wave_time : float = 1.4
var show_wave_timer : float = 0.0
@onready var label = $Control/ColorRect/Label
@onready var box = $Control/ColorRect

func _ready():
	label.visible = false
	box.visible = false

func _process(delta):
	if show_wave_timer < show_wave_time:
		show_wave_timer += delta
	else:
		label.visible = false
		box.visible = false

func update_wave_ui():
	wave += 1
	show_wave_timer = 0
	label.text = wave_string + str(wave)
	label.visible = true
	box.visible = true
