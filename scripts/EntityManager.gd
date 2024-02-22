extends Node

# Entities
var entity_array : Array # not used currently

# Enemy Object References
var enemy_array : Array : 
	get: return enemy_array # Getter
var enemy_projectiles : Array

# Player Object References 
var player
var player_projectiles : Array

# Minimap
@onready var minimap = $Minimap

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

# Functions to adjust the enemy array
func append_enemy(enemy: Object):
	minimap.create_indicator()
	enemy_array.append(enemy)
func remove_enemy(enemy: Object):
	minimap.remove_indicator(enemy)
	enemy_array.erase(enemy)

