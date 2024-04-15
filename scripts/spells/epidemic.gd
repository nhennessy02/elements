extends Node2D

@export var bubblePrefab : PackedScene
@export var speed : float = 500
@export var cooldown : float = 0.3

var wand

var enemy
var attached = false


# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startCooldown(cooldown)
	wand.startFireAnimation()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attached:
		pass
	else:
		position = position + Vector2.from_angle(global_rotation) * speed * delta;
		
	pass
