extends Node

class_name Damageable

@export var health : int = 10
@onready var flashTimer = $FlashTimer
@onready var sprite = $"../Sprite2D"
@onready var damageNumberOrigin = $"../DamageNumberOrigin"

# The bullets call this when colliding with a "Damageable" enemy
func hit(damage : int):
	
	# Take Damage
	health -= damage
	
	#display how much damage taken
	DamageNumbers.display_number(damage, damageNumberOrigin.global_position, Color8(255,50,50))
	
	#flash red on hit
	flashTimer.start()
	sprite.modulate = Color8(255,128,128)
	# Still alive...?
	if health <= 0:
		# Replace with more robust enemy death
		get_parent().die()


func _on_flash_timer_timeout():
	sprite.modulate = Color8(255,255,255)

