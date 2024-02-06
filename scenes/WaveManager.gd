extends Node

# Wave logic
var wave_over : bool = false
var spawn_time : float = 1.0
var spawn_timer : float = 0.0

# Spawn position logic
var rng = RandomNumberGenerator.new()
var screen_width : float = DisplayServer.screen_get_size().x
var screen_height : float = DisplayServer.screen_get_size().y
var distance_multiplier : float = 1.5

# References to other entities
@export var player : PackedScene

# References to enemies to spawn
@export var test_enemy : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	next_wave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wave_over:
		next_wave()
	
	# Time before next enemy spawn
	else:
		spawn_timer += delta
		
		# If enough time has passed...
		if spawn_timer >= spawn_time:
			# Call next part of wave
			pass
			
			# Reset timer
			spawn_timer = 0

# Initializes the next wave
func next_wave():
	wave_over = false

# Returns a random position out of the player's view
func random_spawn_point():
	# General direction / location of spawn
	var current_spawn_point = player.global_position
	var number = rng.randi_range(1, 8)
	match number:
		1: # Top Left
			current_spawn_point += Vector2(-screen_width, -screen_height) * distance_multiplier
		2: # Top Middle
			current_spawn_point += Vector2(0, -screen_height) * distance_multiplier
		3: # Top Right
			current_spawn_point += Vector2(screen_width, -screen_height) * distance_multiplier
		4: # Middle Left
			current_spawn_point += Vector2(-screen_width, 0) * distance_multiplier
		5: # Middle Right
			current_spawn_point += Vector2(screen_width, 0) * distance_multiplier
		6: # Bottom Left
			current_spawn_point += Vector2(-screen_width, screen_height) * distance_multiplier
		7: # Bottom Middle
			current_spawn_point += Vector2(0, screen_height) * distance_multiplier
		8: # Bottom Right
			current_spawn_point += Vector2(screen_width, screen_height) * distance_multiplier
	
	# Return Vector2 position
	return current_spawn_point

# Adds variation to the spawn points of enemies
# CURRENTLY CAN SPAWN ON TOP OF OTHER ENEMIES / OBJECTS
func add_pos_variation(range_min: float = -100, range_max: float = 100):
	# Introduce variation
	var x_pos_variation = rng.randf_range(range_min, range_max)
	var y_pos_variation = rng.randf_range(range_min, range_max)
	return Vector2(x_pos_variation, y_pos_variation)

# Spawns a group of enemies in random positions
func spawn_enemies(count: int, enemy_type: PackedScene):
	for n in count:
		spawn(enemy_type)

# Spawns a group of enemies in an organized cluster
func spawn_enemies_at_rand_pos(count: int, enemy_type: PackedScene, variation: bool = false):
	var position = random_spawn_point()
	for n in count:
		spawn_at_pos(enemy_type, position, variation)

# Spawns an enemy of a given type at a random position
func spawn(enemy_type: PackedScene):
	# Creates an enemy in the scene
	var enemy = enemy_type.instantiate()
	get_tree().current_scene.add_child(enemy)
	
	# Randomly determine enemy position
	enemy.global_position = random_spawn_point() + add_pos_variation()

# Spawns an enemy of a given type at a set position
func spawn_at_pos(enemy_type: PackedScene, position: Vector2, has_variation: bool):
	# Creates an enemy in the scene
	var enemy = enemy_type.instantiate()
	get_tree().current_scene.add_child(enemy)
	
	# Determine enemy position
	enemy.global_position = position
	
	# Add random variation if needed
	if has_variation:
		enemy.global_position += add_pos_variation()
