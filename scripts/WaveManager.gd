extends Node

# Wave logic
var wave_over : bool = false
var spawning_over : bool = false
var spawn_time : float = 1.0
var spawn_timer : float = 0.0

# Spawn position logic
var rng = RandomNumberGenerator.new()
var spawn_range_width : float 
var spawn_range_height : float
var distance_multiplier : float = 1.5

# Random Wave Generator
@export var r_stages_min : int = 5
@export var r_stages_max : int = 10
@export var r_count_min : int = 3
@export var r_count_max : int = 8
@export var r_time_min : float = 2.5
@export var r_time_max : float = 7.0
@export var random_enemy_array : Array[PackedScene]

# References to other entities
var player

# Waves Array(s)
@export var wave_stages : Array[Array]
var current_stage_index : int	# the index of the active stage of the wave in the array

# Wave Counter
@onready var wave_counter_ui = $WaveCounter

# When creating a wave in the inspector: 
# 1) create a new element in the array
# 2) add 4 elements to the new array
# 3) the types for each element are in order: int, object, float, bool

# Contained 2 levels deep in the array
var enemy_count : int				# the number of enemies spawned at each stage of the wave
var enemy_type : PackedScene		# the type of enemy spawned at each stage of the wave
var time_between_spawns : float		# time before next stage of the wave
var spawns_grouped : bool			# are enemies spawned together or randomly?

# Indexes to avoid hard coding and make for easier editing
const i_count : int = 0		# Index of the enemy COUNT
const i_type : int = 1		# Index of the enemy TYPE
const i_time : int = 2		# Index of the TIME before next enemies are spawned
const i_grouped : int = 3	# Index of the bool that determines grouped vs random positioning

# Entity Manager
var entity_manager

# Spawning Bounds
@export var bounds_x : float = 1000.0
@export var bounds_y : float = 1000.0
var acceptable_spawn_dist : float = 600

# Tracks if Random Waves are being generated
var random : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():	
	# Entity manager reference
	if get_tree().get_first_node_in_group("EntityManager"):
		entity_manager = get_tree().get_first_node_in_group("EntityManager")
	else:
		entity_manager = null
	
	# Initialize spawn bounds
	spawn_range_width = get_viewport().get_visible_rect().size.x / 2
	spawn_range_height = get_viewport().get_visible_rect().size.y / 2
	
	# Reference to player used to position other spawns
	player = get_tree().get_nodes_in_group("Player")[0]
	
	# If there is a custom wave run it
	if wave_stages.size() > 0:
		wave_counter_ui.update_wave_ui()
		next_wave()
	
	# Otherwise run a random wave
	else:
		wave_counter_ui.update_wave_ui()
		random_wave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Go to the element combination scene after the wave is completed
	if wave_over:
		# If there is a custom wave run it
		if !random:
			next_wave()
		# Otherwise run a random wave
		else:
			wave_counter_ui.update_wave_ui()
			random_wave()
	
	# During a wave...
	else:
		# Length between enemy spawns
		spawn_timer += delta
		
		# If enough time has passed...
		if spawn_timer >= spawn_time:
			# Reset timer
			spawn_timer = 0
			# Call next stage of the wave if there is one
			if current_stage_index < wave_stages.size():
				call_wave_element(current_stage_index)
		
		# If all enemies are defeated and all stages are completed -> wave is over
		check_if_wave_over()

# Initializes the next wave
func next_wave():
	wave_over = false
	current_stage_index = 0
	call_wave_element(current_stage_index)

# Creates a random wave if there is no wave built in the inspector
func random_wave():
	wave_over = false
	random = true
	current_stage_index = 0
	
	# Determine number of stages in the wave
	var r_stages : int = rng.randi_range(r_stages_min, r_stages_max)
	
	# Generate random wave array
	for stage in r_stages:
		# Construct the array which will have its values later redefined
		var new_data = [r_count_min, random_enemy_array[0], r_time_min, false]
		wave_stages.append(new_data)
		
		# Get random values for int variables
		wave_stages[stage][i_count] = rng.randi_range(r_count_min, r_count_max)
		wave_stages[stage][i_time] = rng.randf_range(r_time_min, r_time_max)
		
		# Get a random enemy type to spawn from the array in the inspector
		var r_enemy_index = rng.randi_range(0, random_enemy_array.size() - 1)
		wave_stages[stage][i_type] = random_enemy_array[r_enemy_index]
		
		# 50/50 whether the enemies are grouped or randomly placed
		if rng.randi_range(0, 1) == 0:
			wave_stages[stage][i_grouped] = true
		else:
			wave_stages[stage][i_grouped] = false
	
	call_wave_element(current_stage_index)

# Gets information from the waves array to spawn new enemies as part of the wave
func call_wave_element(index: int):
	# Load stage information from the wave array
	enemy_count = wave_stages[index][i_count]
	enemy_type = wave_stages[index][i_type]
	time_between_spawns = wave_stages[index][i_time]
	spawns_grouped = wave_stages[index][i_grouped]
	
	# Set new time between stages
	spawn_time = time_between_spawns
	
	# If the spawned enemies appear in a similar location
	if spawns_grouped:
		spawn_enemies_at_pos(enemy_count, enemy_type)
		
	# If the spawned enemies are spawned randomly
	else:
		spawn_enemies(enemy_count, enemy_type)
	
	# Increase index in array if there is another element in the wave
	current_stage_index += 1
	
	# Sets a bool to stop iterating through elements of the spawner array
	if current_stage_index >= wave_stages.size():
		spawning_over = true

# Returns a random position out of the player's view
func random_spawn_point():
	# General direction / location of spawn
	var current_spawn_point = player.position
	var number = rng.randi_range(1, 8)
	match number:
		1: # Top Left
			current_spawn_point += Vector2(-spawn_range_width, -spawn_range_height) * distance_multiplier
		2: # Top Middle
			current_spawn_point += Vector2(0, -spawn_range_height) * distance_multiplier
		3: # Top Right
			current_spawn_point += Vector2(spawn_range_width, -spawn_range_height) * distance_multiplier
		4: # Middle Left
			current_spawn_point += Vector2(-spawn_range_width, 0) * distance_multiplier
		5: # Middle Right
			current_spawn_point += Vector2(spawn_range_width, 0) * distance_multiplier
		6: # Bottom Left
			current_spawn_point += Vector2(-spawn_range_width, spawn_range_height) * distance_multiplier
		7: # Bottom Middle
			current_spawn_point += Vector2(0, spawn_range_height) * distance_multiplier
		8: # Bottom Right
			current_spawn_point += Vector2(spawn_range_width, spawn_range_height) * distance_multiplier
	
	# Reposition if necessary
	current_spawn_point = move_in_bounds(current_spawn_point)
	current_spawn_point = away_from_player(current_spawn_point)
	
	# Return Vector2 position
	return current_spawn_point

# Adds variation to the spawn points of enemies
func add_pos_variation(range_min: float = -25, range_max: float = 25):
	# Introduce variation
	var x_pos_variation = rng.randf_range(range_min, range_max)
	var y_pos_variation = rng.randf_range(range_min, range_max)
	
	# Reposition if out of bounds
	var spawn_vec : Vector2 = Vector2(x_pos_variation, y_pos_variation)
	
	# Return Vector2 position
	return spawn_vec

# Reposition a spawning vector if out of bounds
func move_in_bounds(current_pos: Vector2):
	if current_pos.x < -bounds_x: 
		current_pos.x = -bounds_x
	if current_pos.x > bounds_x:
		current_pos.x = bounds_x
	if current_pos.y < -bounds_y:
		current_pos.y = -bounds_y
	if current_pos.y > bounds_y:
		current_pos.y = bounds_y
	return current_pos

func away_from_player(current_pos: Vector2):
	# If the spawn point is too close to the player move it
	if current_pos.distance_to(player.position) < acceptable_spawn_dist:
		
		var far_x : float = 0
		var far_y : float = 0
		
		# Get X and Y coordinates far away from the player
		if player.position.x > 0:
			far_x = player.position.x - acceptable_spawn_dist
		else:
			far_x = player.position.x + acceptable_spawn_dist
		if player.position.y > 0:
			far_y = player.position.y - acceptable_spawn_dist
		else:
			far_y = player.position.y + acceptable_spawn_dist
		
		# Update spawn position vector
		current_pos.x = far_x
		current_pos.y = far_y
	
	return current_pos

# Spawns a group of enemies in random positions
func spawn_enemies(count: int, type: PackedScene):
	for n in count:
		spawn(type)

# Spawns a group of enemies in an organized cluster
func spawn_enemies_at_pos(count: int, type: PackedScene, variation: bool = true):
	var position = random_spawn_point()
	for n in count:
		spawn_at_pos(type, position, variation)

# Spawns an enemy of a given type at a random position
func spawn(type: PackedScene):
	# Creates an enemy in the scene
	var enemy = type.instantiate()
	add_child(enemy)
	entity_manager.append_enemy(enemy)
	
	# Randomly determine enemy position
	enemy.position = random_spawn_point() + add_pos_variation()

# Spawns an enemy of a given type at a set position
func spawn_at_pos(type: PackedScene, position: Vector2, has_variation: bool = true):
	# Creates an enemy in the scene
	var enemy = type.instantiate()
	add_child(enemy)
	
	# Determine enemy position
	entity_manager.append_enemy(enemy)
	enemy.position = position
	
	# Add random variation if needed
	if has_variation:
		enemy.position += add_pos_variation()

# Sets wave_over to true if there are no more enemies to spawn, and the rest are dead
func check_if_wave_over():
	var enemies_left = entity_manager.enemy_array
	if enemies_left.size() == 0 and spawning_over:
		wave_over = true
