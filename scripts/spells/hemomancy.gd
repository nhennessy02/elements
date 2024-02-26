extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for projectile in self.get_children():
		projectile.global_position = self.global_position
		projectile.global_rotation = self.global_rotation



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
