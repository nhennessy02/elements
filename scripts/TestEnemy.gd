extends Node

# Tweak to adjust movement
@export var seek_weight : float = 1
@export var separate_weight : float = 9
@export var wander_weight : float = 1
@export var flee_weight : float = 1
@export var avoid_weight : float = 5

# Outline behaviors
func calc_steering_forces():	
	owner.total_steering_force += owner.pathfinding() * seek_weight
	owner.total_steering_force += owner.separate() * separate_weight
