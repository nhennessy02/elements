extends Node2D

var projectileScene

# Called when the node enters the scene tree for the first time.
func _ready():
	projectileScene = preload("res://scenes/base_projectile.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("fire_wand"):
		fire()

func fire():
	var projectile = projectileScene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = self.global_position
	projectile.global_rotation = self.global_rotation
	
