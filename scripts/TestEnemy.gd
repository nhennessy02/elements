extends Node

# Tweak to adjust movement
@export var seek_weight : float = 1
@export var separate_weight : float = 4

# Outline behaviors
func calc_steering_forces():
	owner.total_steering_force += owner.separate() * separate_weight
	
	if owner.player != null: # In case no player defined
		owner.total_steering_force += owner.seek(owner.player.global_position) * seek_weight