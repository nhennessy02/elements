class_name Enemy extends CharacterBody2D

# Used for every enemy
# Change these variables in the Inspector
@export var speed : float = 200.0
@export var damage : int = 1

# We assign this in _ready()
var player:
	get: return player

@onready var physics_object = $PhysicsObject

# Gives references to other entities
var entity_manager
var wave_manager : Node

# Half of the width and height
var halfwidth_x : float
var halfwidth_y : float

# Wandering Variables
var wander_pos : Vector2
var wander_angle : float
var wander_radius : float

# Used to calculate movement/forces
var total_steering_force : Vector2 = Vector2.ZERO
@export var max_force : Vector2 = Vector2(200.0, 200.0)

func _ready(): # LACKS DEFAULTS IN CASE OF MISSING PLAYER OR ENTITY MANAGER
	entity_manager = get_tree().get_first_node_in_group("EntityManager")
	
	# Gets the bounds
	wave_manager = get_parent()
	halfwidth_x = wave_manager.bounds_x
	halfwidth_y = wave_manager.bounds_y
	
	# Finds the player and gets a reference to it
	player = entity_manager.player

func _physics_process(_delta):
	# Apply all steering forces to the enemy's movements
	total_steering_force = Vector2.ZERO
	get_node("Behavior").calc_steering_forces()
	total_steering_force = total_steering_force.clamp(-max_force, max_force)
	physics_object.apply_force(total_steering_force)

# Damages the player when they enter the enemy's hitbox
func _on_hit_box_body_entered(body):
	for child in body.get_children():
		if child is DamageablePlayer:
			child.hit(damage) # calls hit in damageable_player.gd

# Movement function: Enemies move towards player position
func seek(seek_target_pos: Vector2):
	# Get desired velocity
	var desired_velocity : Vector2 = seek_target_pos - physics_object.position
	
	# Scale to enemy's speed
	desired_velocity = desired_velocity.normalized() * speed
	
	# Calculate and return the force needed to move towards target
	var seekForce : Vector2 = desired_velocity - physics_object.velocity
	return seekForce;

func flee(flee_target_pos: Vector2):
	# Determind desired flee velocity
	var desired_velocity : Vector2 = physics_object.position - flee_target_pos
	
	# Scale to enemy speed
	desired_velocity = desired_velocity.normalized() * speed;
	
	# Calculate and return the fleeing force
	var flee_force : Vector2 = desired_velocity - physics_object.velocity
	return flee_force

# Movement function: Enemies separate from each other
func separate():
	var seperate_force : Vector2 = Vector2.ZERO
	var sqr_dist : float
	
	# Flee all other enemies
	for enemy in entity_manager.enemy_array:
		if enemy != self:
			sqr_dist = (physics_object.position - enemy.position).length()
			
			# Scale flee based on distance
			if sqr_dist != 0:
				seperate_force += flee(enemy.position) * (1.0/sqr_dist)
	
	# Return total separate force
	return seperate_force;

func wander(future_time: float = 0.5, wander_radius: float = 2.0):
	wander_pos = calc_future_position(future_time)
	
	wander_pos.x += cos(wander_angle) * wander_radius
	wander_pos.y += sin(wander_angle) * wander_radius
	
	return seek(wander_pos)

func change_wander_angle(wander_radius: float = 2.0):
	wander_angle = randf_range(0.0, 360.00)
	wander_angle = deg_to_rad(wander_angle)

func calc_future_position(time: float = 0.5):
	return physics_object.position + physics_object.velocity * time

func die():
	entity_manager.remove_enemy(self)
	queue_free()
