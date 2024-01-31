extends Node2D

var projectileScene

@onready var spawnPoint = $ProjectileSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	projectileScene = preload("res://scenes/base_projectile.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("fire_wand"): #left mouse click
		fire()

func fire():
	var projectile = projectileScene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = spawnPoint.global_position #sets spawnpoint at the spawnpoint node
	projectile.global_rotation = self.global_rotation
	
