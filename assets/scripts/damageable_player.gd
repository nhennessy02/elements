extends Node

# SPECIFICALLY FOR THE PLAYER

class_name DamageablePlayer
@export var health : int = 3;

@onready var ui : UI = %UI
func _ready():
	print(ui);
# Enemies and enemy bullets will call this when colliding with the player
func hit(damage : int):
	
	# Take Damage
	health -= damage
	ui.update_health_label(health)
	
	# Still alive...?
	if health <= 0:
		# Replace with more robust death / game over
		get_parent().queue_free()
