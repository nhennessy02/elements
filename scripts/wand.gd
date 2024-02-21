extends Node2D

# Firing delay & hold to fire
@export var fire_rate : float = 0.4 
var fire_timer : float = 0
var can_fire : bool = true
var mousePos

@export var projectileScene : PackedScene

@onready var sprite = $Sprite2D
@onready var spawnPoint = $Sprite2D/ProjectileSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mousePos = get_global_mouse_position()
	
	#Flip to face the mouse
	if mousePos.x < global_position.x:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	look_at(mousePos)
	
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
	
	
