extends Node2D

# Firing delay & hold to fire
@export var fire_rate : float = 0.4 
var fire_timer : float = 0
var can_fire : bool = true

@export var projectileScene : PackedScene
@export var rayScene : PackedScene

@onready var spawnPoint = $ProjectileSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	
	# Firing Cooldown
	fire_timer += delta
	if fire_timer >= fire_rate:
		can_fire = true
	else:
		can_fire = false
	
	# Input event
	if Input.is_action_pressed("fire_wand") and can_fire: #left mouse click
		fire()



func fire():
	
	# reset timer
	fire_timer = 0
	var projectile = projectileScene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = spawnPoint.global_position #sets spawnpoint at the spawnpoint node
	projectile.global_rotation = self.global_rotation
	
	#var ray = rayScene.instantiate()
	#get_tree().current_scene.add_child(ray)
	#ray.global_position = spawnPoint.global_position
	#ray.global_rotation = spawnPoint.global_rotation

