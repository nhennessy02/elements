extends Node2D

@onready var sprite = $StaticBody2D/Sprite2D
@onready var staticbody = $StaticBody2D
@onready var lifetimer = $LifeTimer
@export var indicator : Texture2D
@export var wall : Texture2D
var active = false
var max_range = 10
var min_range = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("fire_wand") and not active:
		pass
		#staticbody.position = get_viewport().get_mouse_position()
	#elif not active:
	elif not active:
		active = true
		lifetimer.start()
		sprite.texture = wall


func _on_life_timer_timeout():
	queue_free()
	pass # Replace with function body.
