extends Node

# Wave logic
var wave_over : bool = false
var spawning_over : bool = false
var spawn_time : float = 1.0
var spawn_timer : float = 0.0

# Spawn position logic
var rng = RandomNumberGenerator.new()
var spawn_range_width : float = 300		# FIX VALUE
var spawn_range_height : float = 500	# FIX VALUE
var distance_multiplier : float = 1.5

# References to other entities
var player

# Waves Array(s)
@export var wave_stages : Array[Array]
var current_stage_index : int	# the index of the active stage of the wave in the array

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

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	next_wave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Go to the element combination scene after the wave is completed
	if wave_over:
		# REPLACE WITH SCENE TRANSITION
		get_tree().quit() 
	
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

# Gets information from the waves array to spawn new enemies as part of the wave
func call_wave_element(index: int):
	enemy_count = wave_stages[index][i_count]
	enemy_type = wave_stages[index][i_type]
	time_between_spawns = wave_stages[index][i_time]
	spawns_grouped = wave_stages[index][i_grouped]
	
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
	var current_spawn_point = player.global_position
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
	
	# Randomly determine enemy position
	enemy.global_position = random_spawn_point() + add_pos_variation()

# Spawns an enemy of a given type at a set position
func spawn_at_pos(type: PackedScene, position: Vector2, has_variation: bool = false):
	# Creates an enemy in the scene
	var enemy = type.instantiate()
	add_child(enemy)
	
	# Determine enemy position
	enemy.global_position = position
	
	# Add random variation if needed
	if has_variation:
		enemy.global_position += add_pos_variation()

# REPLACE LOGIC USING A REFERENCE TO AN ENEMY MANAGER
# Sets wave_over to true if there are no more enemies to spawn, and the rest are dead
func check_if_wave_over():
	var enemies_left = self.get_children().size()
	if enemies_left == 0 and spawning_over:
		wave_over = true
