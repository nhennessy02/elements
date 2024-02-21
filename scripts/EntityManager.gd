extends Node

# Entities
var entity_array : Array

# Enemy Object References
var enemy_array : Array : 
	get: return enemy_array # Getter
var enemy_projectiles : Array

# Player Object References 
var player
var player_projectiles : Array

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

# Functions to adjust the enemy array
func append_enemy(enemy: Object):
	enemy_array.append(enemy)
func remove_enemy(enemy: Object):
	enemy_array.erase(enemy)
