extends Node2D

@onready var sprite = $Sprite2D

@export var speed : float = 1000
@export var damage : int = 6
@export var cooldown : float = 10
var wand

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startFireAnimation()
	wand.startCooldown(cooldown)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.rotate(deg_to_rad(2))
	speed -= 4;
	position = position + Vector2.from_angle(rotation) * speed * delta;
	pass


func _on_area_2d_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage);
	pass # Replace with function body.


func _on_life_timer_timeout():
	queue_free()
	pass # Replace with function body.
