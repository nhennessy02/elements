extends Node2D

@export var speed : float = 700
@export var damage : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.from_angle(rotation) * speed * delta;
	pass

func _on_area_2d_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage);
			EffectManager.attach_effect(body,Effects.BLEED,3)
	queue_free()		


func _on_lifetime_timeout():
	queue_free()
	pass # Replace with function body.
