extends Node2D

@export var Projectile : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("hemomancy roataion:")
	print(rotation_degrees)
	
	#var projectile = Projectile.instantiate()
	#get_tree().current_scene.add_child(projectile)
	#projectile.global_position = self.global_position
	#projectile.global_rotation = self.global_rotation
	
	#self.global_rotation=0
	for projectile in self.get_children():
		projectile.global_position = self.global_position
		projectile.global_rotation = self.global_rotation + projectile.global_rotation
	#	print("projectile position and rotation")
	#	print(projectile.rotation)
	#	print(projectile.global_rotation)
	#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
