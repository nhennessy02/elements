extends Node

# SPECIFICALLY FOR THE PLAYER

class_name DamageablePlayer
@export var health : int = 5
@export var maxHealth : int = 5
@export var shield : int = 0
@export var maxShield : int = 3
@onready var damageNumberOrigin = $"../DamageNumberOrigin"

signal health_changed(value : int)
signal shield_changed(value: int)

# Enemies and enemy bullets will call this when colliding with the player
func hit(damage : int, hit_pos : Vector2 = Vector2.ZERO):
	
	# Take Damage
	if !owner.invulnerable:
		DamageNumbers.display_number(damage,damageNumberOrigin.global_position, Color8(255,50,50)) # red
		
		if shield >= damage:
			shield = shield - damage
			damage = 0
		if damage > shield:
			damage = damage - shield
			shield = 0
		
		health -= damage
		health_changed.emit(health)
		shield_changed.emit(shield)
		$"../AnimationPlayer".play("hurt")
		
		# Calc which direction to knock back player
		var dir : Vector2 = (owner.position - hit_pos).normalized()
		owner.kb_dir = dir
	
	if damage > 0:
		owner.invulnerable = true
		owner.knockingback = true
	
	# Still alive...?
	if health <= 0:
		owner.gameover()
		
func heal(value : int):
	if health + value > maxHealth:
		health = maxHealth
	else:
		health += value
	DamageNumbers.display_number(value,damageNumberOrigin.global_position, Color8(50,255,50)) # green
	health_changed.emit(health)

func addToShield(value : int):
	if shield + value > maxShield:
		shield = maxShield
	else:
		shield += value
	DamageNumbers.display_number(value,damageNumberOrigin.global_position, Color8(50,50,255))
	shield_changed.emit(shield)
