extends CanvasLayer

var player
var entity_manager : Node
@export var map_range : float = 1300
const max_idtr_dist : float = 115

# INDICATORS ON THE MAP
@export var player_idtr : PackedScene
@export var enemy_idtr : PackedScene
@export var item_idtr : PackedScene
var indicator_array : Array
var player_indicator

const player_idtr_vec2_multiplier : float = 8.0
const player_idtr_lerp : float = 0.1

@onready var map_sprite = $Control/MapSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	entity_manager = owner
	player = get_tree().get_nodes_in_group("Player")[0]
	
	# Initialize Player Indicator
	player_indicator = player_idtr.instantiate()
	add_child(player_indicator)
	player_indicator.position = map_sprite.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Display these entities on the minimap relative to the player
	move_indicators()
	display_indicators()

# Create an indicator whenever an enemy is spawned
func create_indicator():
	var indicator = enemy_idtr.instantiate()
	add_child(indicator)
	indicator_array.append(indicator)

# Delete the indicator when the enemy dies or is removed
func remove_indicator(enemy: Object):
	var idtr_index = entity_manager.enemy_array.find(enemy) # get the deleted enemy's index
	indicator_array[idtr_index].visible = false
	indicator_array.remove_at(idtr_index) # removes the indicator

# Moves the indicators on the minimap
func move_indicators():
	# MOVE ENEMY INDICATORS
	for indicator in indicator_array:
		# Get a normalized vector representing the indicator's position
		var idtr_pos : Vector2 = Vector2.ZERO
		var index : int = indicator_array.find(indicator)
		var enemy_pos : Vector2 = entity_manager.enemy_array[index].position
		var player_pos : Vector2 = player.position
		idtr_pos = player_pos.direction_to(enemy_pos)
		
		# Multiply the vector depending on how far the enemy is from the player
		var dist_multiplier : float = (player_pos.distance_to(enemy_pos) / map_range) * max_idtr_dist
		indicator.position = idtr_pos * dist_multiplier
		
		# Move the indicator within the map sprite's space
		indicator.position += map_sprite.position
	
	# Make player's indicator move slightly depending on player's direction
	var player_idtr_vector_adjust : Vector2 = player.direction * player_idtr_vec2_multiplier
	player_indicator.position = player_indicator.position.lerp(player_idtr_vector_adjust + map_sprite.position, player_idtr_lerp)

# Controls the visibility of indicators
func display_indicators():
	var enemies = entity_manager.enemy_array
	
	# Determines whether to display an enemy's indicator 
	# or not based on the distance from the player
	for i in indicator_array.size():
		if enemies[i].position.distance_to(player.position) <= map_range:
			indicator_array[i].visible = true
		else:
			indicator_array[i].visible = false
