extends Node2D

@export var speed : float = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.from_angle(rotation) * speed * delta;
	pass


func _on_area_2d_enemies_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			EffectManager.attach_effect(child,Effects.SLOW,10)
	pass # Replace with function body.


func _on_area_2d_walls_body_entered(body):
	queue_free()
	pass # Replace with function body.
