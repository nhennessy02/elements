class_name Enemy extends CharacterBody2D

# Used for every enemy
# Change these variables in the Inspector
@export var speed : float = 150.0
@export var damage : int = 1

# Pathfinding Variables
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

#Animation player
@onready var animPlayer = $AnimationPlayer as AnimationPlayer

# We assign this in _ready()
var player:
	get: return player

# Gives references to other entities
var entity_manager
var wave_manager : Node

# Half of the width and height
var halfwidth_x : float
var halfwidth_y : float

# Wandering Variables
var wander_pos : Vector2
var wander_angle : float

# Avoid Obstacle Variables
var avoid_future_time : float = 0.1
var avoid_radius : float = 800.0

# Used to calculate movement/forces
var direction : Vector2 = Vector2.ZERO
var acceleration : Vector2 = Vector2.ZERO
var total_steering_force : Vector2 = Vector2.ZERO
@export var max_force : Vector2 = Vector2(150.0, 150.0)
@export var mass : float = 1.0
@export var base_item : PackedScene

# Item Drops
@export var item_drop_chance : float = 5.0 # PERCENTAGE OUT OF 100
@export var item_drop_indexes : Array[int] # PESTILENCE = 0, HEMOMANCY = 1, CONVALESCENCE = 2, BONECRAFT = 3, OCCULTISM = 4

# Sprite
@onready var sprite = $Sprite2D

func _ready(): # LACKS DEFAULTS IN CASE OF MISSING PLAYER OR ENTITY MANAGER
	entity_manager = get_tree().get_first_node_in_group("EntityManager")
	
	# Gets the bounds
	wave_manager = get_parent()
	halfwidth_x = wave_manager.bounds_x
	halfwidth_y = wave_manager.bounds_y
	
	# Finds the player and gets a reference to it
	player = entity_manager.player
	
	# Play spawning animation
	animPlayer.play("spawn")
	
	#Plays idle animation when the spawn animation finishes
	animPlayer.queue("base")
	
	# Delay to prevent pathfinding errors
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta):
	# Calc velocity each frame
	velocity += acceleration * delta
	position += velocity * delta
	
	# Get direction based on velocity
	direction = velocity.normalized()
	
	# Zero acceleration
	acceleration = Vector2.ZERO
	
	# Apply all steering forces to the enemy's movements
	total_steering_force = Vector2.ZERO
	get_node("Behavior").calc_steering_forces()
	total_steering_force = total_steering_force.clamp(-max_force, max_force)
	apply_force(total_steering_force)
	
	# Activate Collisions with Tilemap
	move_and_slide()
	
	# Flip the enemy's sprite
	if velocity.x > 0 and abs(velocity.x) > 2:
		sprite.flip_h = true
	elif velocity.x < 0 and abs(velocity.x) > 2:
		sprite.flip_h = false
		

# Applies movement to the enemy
func apply_force(force: Vector2):
	acceleration += force * mass

# Damages the player when they enter the enemy's hitbox
func _on_hit_box_body_entered(body):
	for child in body.get_children():
		if child is DamageablePlayer:
			child.hit(damage, position) # calls hit in damageable_player.gd

# Find the fastest route to the player without collisions
func pathfinding():
	return seek(nav_agent.get_next_path_position())

# Get a path for pathfinding
func make_path():
	nav_agent.target_position = player.position
func _make_new_path_on_timeout():
	make_path()

# Movement function: Enemies move towards player position
func seek(seek_target_pos: Vector2):
	# Get desired velocity
	var desired_velocity : Vector2 = seek_target_pos - position
	
	# Scale to enemy's speed
	desired_velocity = desired_velocity.normalized() * speed
	
	# Calculate and return the force needed to move towards target
	var seekForce : Vector2 = desired_velocity - velocity
	return seekForce;

# Move away from a target
func flee(flee_target_pos: Vector2):
	# Determind desired flee velocity
	var desired_velocity : Vector2 = position - flee_target_pos
	
	# Scale to enemy speed
	desired_velocity = desired_velocity.normalized() * speed;
	
	# Calculate and return the fleeing force
	var flee_force : Vector2 = desired_velocity - velocity
	return flee_force

# Move away from a target's projected future position
func evade(future_time: float = 1.0):
	# Determind future position of player
	var future_player_pos : Vector2 = player.position + player.velocity * future_time
	# Flee the estimated future position
	return flee(future_player_pos)

# Movement function: Enemies separate from each other
func separate():
	var seperate_force : Vector2 = Vector2.ZERO
	var sqr_dist : float
	
	# Flee all other enemies
	for enemy in entity_manager.enemy_array:
		if enemy != self:
			sqr_dist = (position - enemy.position).length()
			
			# Scale flee based on distance
			if sqr_dist != 0:
				seperate_force += flee(enemy.position) * (1.0/sqr_dist)
	
	# Return total separate force
	return seperate_force;

# Avoid obstacles in the entity manager
func avoid_obstacle():
	var avoid_force : Vector2 = Vector2.ZERO
	var vec_to_obstacle : Vector2 = Vector2.ZERO
	var right_dot : float
	var forward_dot : float
	
	var future_pos : Vector2 = calc_future_position(avoid_future_time)
	var future_sqr_dist : float = (future_pos - position).length()
	future_sqr_dist += avoid_radius
	
	# Avoids all obstacles with varying weight depending on their distance
	for obstacle in entity_manager.obstacles_array:
		vec_to_obstacle = obstacle.position - position
		forward_dot = vec_to_obstacle.dot(Vector2.UP)
		
		if forward_dot >= 0 and forward_dot * forward_dot <= future_sqr_dist:
			right_dot = vec_to_obstacle.dot(Vector2.RIGHT)
			
			if abs(right_dot) <= avoid_radius:
				if right_dot < 0: # TURN RIGHT
					avoid_force += Vector2.RIGHT * max_force * (1/forward_dot)
				else: # TURN LEFT
					avoid_force += -Vector2.RIGHT * max_force * (1/forward_dot)
	
	return avoid_force

# Wanders in a random direction
func wander(future_time: float = 0.5, wander_radius: float = 2.0):
	wander_pos = calc_future_position(future_time)
	
	wander_pos.x += cos(wander_angle) * wander_radius
	wander_pos.y += sin(wander_angle) * wander_radius
	
	return seek(wander_pos)

# Change the angle at which the agent is wandering
func change_wander_angle():
	wander_angle = randf_range(0.0, 360.00)
	wander_angle = deg_to_rad(wander_angle)

# find where this agent will be after X time
func calc_future_position(time: float = 1.0):
	return position + velocity * time

# Called when an enemy is killed
# random chance to drop an item
func drop_item(): 
	if randi_range(0, 100) < item_drop_chance:
		var item_drop = base_item.instantiate() # drop item
		get_tree().root.add_child.call_deferred(item_drop)
		item_drop.position = position # set item position to enemy position
		
		# Get a random item from the items that the enemy can potentially drop
		var index = randi_range(0, item_drop_indexes.size() - 1)
		item_drop.get_child(2).setId(item_drop_indexes[index])

# NEEDS TO PLAY A DEATH ANIMATION FIRST
func die():
	animPlayer.play("death")
	
	#Stops the enemy and makes hit/hurtboxes inactive
	set_physics_process(false)
	$HurtBox.set_deferred("disabled",true)
	$HitBox.set_deferred("monitoring",false)
	$Behavior.alive = false
	
	# wait until the animation finishes, then die for realsies
	await animPlayer.animation_finished
	
	drop_item()
	entity_manager.remove_enemy(self)
	queue_free()
	
