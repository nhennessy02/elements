extends Node

# Tweak to adjust movement
@export var seek_weight : float = 1
@export var separate_weight : float = 12
@export var wander_weight : float = 1
@export var flee_weight : float = 1

# Outline behaviors
func calc_steering_forces():	
	if owner.halted:
		owner.total_steering_force += owner.separate() * separate_weight
		owner.total_steering_force += owner.wander() * wander_weight
	else:
		owner.total_steering_force += owner.separate() * separate_weight
		owner.total_steering_force += owner.seek(owner.player.position) * seek_weight
