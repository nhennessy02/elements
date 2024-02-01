extends Node

class_name Damageable

@export var health : int = 10

# The bullets call this when colliding with a "Damageable" enemy
func hit(damage : int):
	
	# Take Damage
	health -= damage
	
	# Still alive...?
	if health <= 0:
		# Replace with more robust enemy death
		get_parent().queue_free()
