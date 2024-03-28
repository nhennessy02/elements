extends Node2D

var direction: Vector2 = Vector2.ZERO
var active: bool = true

@export var speed : float = 30
@export var damage : int = 1

var player_pos : Vector2 = Vector2.ZERO

func _ready():
	direction = (player_pos - position).normalized() # direction is set to the normalized vector towards the player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if active:
		position += direction * speed * delta;
	else: # delete projectile once inactive
		queue_free()

# Calls when the bullet collides with another object
func _on_area_2d_body_entered(body):	
	for child in body.get_children():
		if child is DamageablePlayer and active:
			child.hit(damage, position) # calls hit in damageable_player.gd
			active = false
	
	active = false
