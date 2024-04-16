extends Node2D

@export var bubblePrefab : PackedScene
@export var speed : float = 300
@export var cooldown : float = 6

@onready var ProjectileNode = $Projectile
@onready var BubbleNode = $Bubble
@onready var LifeTimer : Timer = $LifeTimer

var damagePerTick = 1
var enemyList = []

var wand

var enemy
var attached = false


# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startCooldown(cooldown)
	wand.startFireAnimation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attached:
		if is_instance_valid(enemy):
			position = enemy.global_position	
	else:
		position = position + Vector2.from_angle(global_rotation) * speed * delta;

func _on_projectile_area_2d_body_entered(body):
	enemy = body
	attached = true;
	ProjectileNode.get_node("ProjectileArea2D/CollisionShape2D").set_deferred("disabled", true)
	ProjectileNode.set_deferred("visible",false)
	ProjectileNode.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
	
	BubbleNode.get_node("BubbleArea2D/CollisionShape2D").set_deferred("disabled",false)
	BubbleNode.set_deferred("visible", true)
	BubbleNode.set_deferred("process_mode",Node.PROCESS_MODE_INHERIT)
	
	LifeTimer.start(5)

func _on_life_timer_timeout():
	queue_free()

func _on_bubble_area_2d_body_entered(body):
	print("body entered")
	enemyList.append(body)

func _on_bubble_area_2d_body_exited(body):
	print("body entered")
	enemyList.erase(body)

func _on_damage_rate_timeout():
	for enemy in enemyList:
		for node in enemy.get_children():
			if node is Damageable:
				node.hit(damagePerTick)
