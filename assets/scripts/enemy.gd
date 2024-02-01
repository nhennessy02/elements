extends CharacterBody2D

# Used for every enemy
# Change these variables in the Inspector
@export var speed : float = 300.0
@export var damage : int = 1

func _physics_process(delta):
	pass

func _on_hit_box_body_entered(body):
	for child in body.get_children():
		if child is DamageablePlayer:
			child.hit(damage)
