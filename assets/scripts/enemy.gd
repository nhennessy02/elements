extends CharacterBody2D

# Used for every enemy
# Change these variables in the Inspector
@export var speed : float = 200.0
@export var damage : int = 1

# We assign this in _ready()
var player

func _ready():
	# Finds the player and gets a reference to it
	if player == null: 
		player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(_delta):
	if player != null:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()

# Damages the player when they enter the enemy's hitbox
func _on_hit_box_body_entered(body):
	for child in body.get_children():
		if child is DamageablePlayer:
			child.hit(damage) # calls hit in damageable_player.gd
