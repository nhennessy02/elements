extends Node2D

@export var speed : float = 700
@export var damage : int = 3
@export var cooldown : float = 1
var wand

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startCooldown(cooldown)
	wand.startFireAnimation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.from_angle(global_rotation) * speed * delta;

func _on_area_2d_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage);
			EffectManager.attach_effect(body,Effects.BLEED,3)

func _on_lifetime_timeout():
	queue_free()
