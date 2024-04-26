extends Node2D
@export var cooldown : float = 5
var wand

@export var speed : float = 300

@onready var Sprite = $Sprite2D
var isSplit = false;
@export var projectilePrefab : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startFireAnimation()
	wand.startCooldown(cooldown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not isSplit:
		position = position + Vector2.from_angle(global_rotation) * speed * delta;
	pass


func _on_split_timer_timeout():
	isSplit = true;
	Sprite.visible = false;
	for i in range(8):
		var projectile = projectilePrefab.instantiate()
		add_child(projectile)
		projectile.global_position = position
		projectile.global_rotation = rotation + (i * deg_to_rad(360/8))


func _on_life_timer_timeout():
	queue_free()
	pass # Replace with function body.
