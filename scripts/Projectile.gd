extends Node2D

var direction
var active : bool = true

@export var speed : float = 500
@export var damage : int = 3
#@export var cooldown : float = 0.3

var wand

@onready var area = $Area2D
@onready var collision_body = $Body

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startBasicCooldown()
	wand.startFireAnimation()
	$AnimationPlayer.play("basic")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if active:
		position = position + Vector2.from_angle(global_rotation) * speed * delta; #Phillip - from_angle gives a unit vector in the direction from the angle given
	else:
		area.monitoring = false
		collision_body.disabled = true

# Calls when the bullet collides with another object
func _on_area_2d_body_entered(body):
	$HitParticles.emitting = true
	
	# Call the enemy's "hit" function when it collides
	for child in body.get_children():
		if child is Damageable and active:
		# Only deal damage if the thing is able to be damaged
			child.hit(damage)
			active = false
		
	# Make the projectile invisible
	$Sprite2D.visible = false
	active = false

# When the particles are finished emitting, delete the projectile object
# Prevents the particles from being destroyed early
# REPLACE WITH ENTITY POOLING
func _on_hit_particles_finished():
	queue_free()
