extends Node2D

@onready var sprite = $StaticBody2D/Sprite2D
@onready var staticbody = $StaticBody2D
@onready var lifetimer = $LifeTimer
@export var indicator : Texture2D
@export var wall : Texture2D
@export var cooldown : float = 5
var active = false
var mousePos
var max_range = 500
var min_range = 100
var player
var wand

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startChargingAnimation()
	player = get_node("../Player")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("fire_wand") and not active:
		mousePos = get_global_mouse_position()
		if(player.position.distance_to(mousePos)>max_range):
			mousePos = player.position + player.position.direction_to(mousePos) * max_range
		if(player.position.distance_to(mousePos)<min_range):
			mousePos = player.position + player.position.direction_to(mousePos) * min_range
		staticbody.global_position = mousePos
		staticbody.look_at(player.position)
	elif not active:
		active = true
		wand.startFireAnimation()
		wand.startCooldown(cooldown)
		lifetimer.start()
		staticbody.set_collision_layer_value(1, true)
		staticbody.set_collision_layer_value(5, true)
		sprite.texture = wall


func _on_life_timer_timeout():
	queue_free()
	pass # Replace with function body.
