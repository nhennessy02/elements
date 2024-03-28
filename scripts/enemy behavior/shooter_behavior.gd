extends Node

# Tweak to adjust movement
@export var seek_weight : float = 1
@export var separate_weight : float = 10
@export var wander_weight : float = 1
@export var flee_weight : float = 8
@export var avoid_weight : float = 5

@export var tracking_start_range : float = 800
@export var evading_start_range : float = 450

var current_state
enum State {
	evading,
	tracking
}

# Projectiles
@export var bullet : PackedScene
@export var min_firing_time : float = 3.0
@export var max_firing_time : float = 5.0
var firing_time
var firing_timer : float = 0.0

# Enemy starts in the TRACKING state
func _ready():
	set_firing_time()
	current_state = State.tracking

func _process(delta):
	# FIRING
	# Fire projectiles while in EVADING or CIRCLING only
	firing_timer += delta
	if firing_timer > firing_time:
		fire()
		firing_timer = 0

# Outline behaviors
func calc_steering_forces():
	# Always separate
	owner.total_steering_force += owner.separate() * separate_weight
	
	# TRACKING
	if current_state == State.tracking: # Chase the player until the enemy is in range
		owner.total_steering_force += owner.pathfinding() * seek_weight
		
		# Change state based on distace to player
		if owner.position.distance_to(owner.player.position) < evading_start_range:
			current_state = State.evading
	
	# EVADING 
	elif current_state == State.evading: # Maintain a distance with the player while firing at them
		owner.total_steering_force += owner.evade() * flee_weight
		
		# Change state based on distace to player
		if owner.position.distance_to(owner.player.position) > tracking_start_range:
			current_state = State.tracking

# Fire a bullet
func fire():
	var new_bullet = bullet.instantiate()
	new_bullet.position = owner.position
	new_bullet.player_pos = owner.player.position
	get_tree().root.add_child.call_deferred(new_bullet)

# Set a random firing time within a given range
func set_firing_time():
	firing_time = randf_range(min_firing_time, max_firing_time)
