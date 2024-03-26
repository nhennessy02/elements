extends Node2D

var direction
var active : bool = true

@export var speed : float = 500
@export var damage : int = 0

@export var cooldown : float = 1
var wand

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startFireAnimation()
	wand.startCooldown(cooldown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.from_angle(global_rotation) * speed * delta;


func _on_area_2d_body_entered(body):
	# Call the enemy's "hit" function when it collides
	for child in body.get_children():
		if child is Damageable and active:
		# Only deal damage if the thing is able to be damaged
			print(body)
			EffectManager.attach_effect(body,Effects.BLEED,6)
			active = false
			queue_free()

