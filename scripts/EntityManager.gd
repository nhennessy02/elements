extends Node

# Entities
var entity_array : Array # not used currently

# Enemy Object References
var enemy_array : Array : 
	get: return enemy_array # Getter
var enemy_projectiles : Array

# Item References
var item_array : Array: 
	get: return item_array # Getter

# Player Object References 
var player
var player_projectiles : Array

# Minimap
@onready var entity_idtr = $EntityIndicatorsUI

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

# Functions to adjust the enemy array
func append_enemy(enemy: Object):
	entity_idtr.create_indicator("enemy")
	enemy_array.append(enemy)
func remove_enemy(enemy: Object):
	entity_idtr.remove_indicator(enemy)
	enemy_array.erase(enemy)
