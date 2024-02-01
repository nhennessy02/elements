extends Node

# SPECIFICALLY FOR THE PLAYER

class_name DamageablePlayer
@export var health : int = 5;

# Enemies and enemy bullets will call this when colliding with the player
func hit(damage : int):
	
	# Take Damage
	health -= damage
	
	# Still alive...?
	if health <= 0:
		# Replace with more robust death / game over
		get_parent().queue_free()
