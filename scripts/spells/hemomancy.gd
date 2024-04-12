extends Node2D

@export var projectilePrefab : PackedScene
@export var cooldown : float = 1
var wand

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startFireAnimation()
	wand.startCooldown(cooldown)
	for i in range(-1,2):
		var projectile = projectilePrefab.instantiate()
		add_child(projectile)
		projectile.global_position = position
		projectile.global_rotation = rotation + (i * deg_to_rad(30))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_lifetime_timeout():
	queue_free()
