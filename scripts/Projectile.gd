extends Node2D

var direction

@export var speed : float = 500
@export var damage : int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.from_angle(global_rotation) * speed * delta; #Phillip - from_angle gives a unit vector in the direction from the angle given

# Calls when the bullet collides with another object
func _on_area_2d_body_entered(body):
	
	# Boolean that lets the bullet be destroyed if it collides with something
	# other than an enemy
	var hit_wall : bool = false
	
	# Call the enemy's "hit" function when it collides
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
			
			# Destroys the bullet on hit
			# REPLACE WITH ENTITY POOLING
			queue_free()
		
		else:
			hit_wall = true
	
	# Hit a wall
	if hit_wall:
		# Destroys the bullet on hit
		# REPLACE WITH ENTITY POOLING
		queue_free()
