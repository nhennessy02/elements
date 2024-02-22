extends Node

# Movement variables
var direction : Vector2 = Vector2.ZERO :
	get : return direction
var position : Vector2 = Vector2.ZERO :
	get : return position
var velocity : Vector2 = Vector2.ZERO :
	get : return velocity
var acceleration : Vector2 = Vector2.ZERO

@export var mass : float = 1.0

func _ready():
	position = owner.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Calc velocity each frame
	velocity += acceleration * delta
	position += velocity * delta
	
	# Get direction based on velocity
	direction = velocity.normalized()
	
	# Update enemy position
	owner.global_position = position
	
	# Keep enemies in bounds
	if position.x >= owner.halfwidth_x:
		position.x = owner.halfwidth_x
	if position.x <= -owner.halfwidth_x:
		position.x = -owner.halfwidth_x
	if position.y >= owner.halfwidth_y:
		position.y = owner.halfwidth_y
	if position.y <= -owner.halfwidth_y:
		position.y = -owner.halfwidth_y
	
	# Zero acceleration
	acceleration = Vector2.ZERO

# Applies movement to the enemy
func apply_force(force: Vector2):
	acceleration += force * mass
