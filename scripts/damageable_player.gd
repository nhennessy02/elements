extends Node

# SPECIFICALLY FOR THE PLAYER

class_name DamageablePlayer
@export var health : int = 3;
@onready var damageNumberOrigin = $"../DamageNumberOrigin"

signal health_changed(value : int)

# Enemies and enemy bullets will call this when colliding with the player
func hit(damage : int, hit_pos : Vector2 = Vector2.ZERO):
	
	# Take Damage
	if !owner.invulnerable:
		health -= damage
		DamageNumbers.display_number(damage,damageNumberOrigin.global_position)
		health_changed.emit(health)
		
		# Calc which direction to knock back player
		var dir : Vector2 = (owner.position - hit_pos).normalized()
		owner.kb_dir = dir
	
	if damage > 0:
		owner.invulnerable = true
		owner.knockingback = true
	
	# Still alive...?
	if health <= 0:
		# Replace with more robust death / game over
		get_tree().quit()
