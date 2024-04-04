extends Node2D

@onready var SearchArea = $SearchArea
@onready var CollisionShape = $SearchArea/CollisionShape2D

@export var speed : float = 700
@export var damage : int = 3
@export var cooldown : float = 1
var wand

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startFireAnimation()
	wand.startCooldown(cooldown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#finding which enemy 
	var nearestChild
	var minDist = Constants.MAX_FLOAT
	for child in SearchArea.get_overlapping_bodies():
		if position.distance_to(child) < minDist:
			minDist = position.distance_to(child)
			nearestChild = child
	position = position + Vector2.from_angle(global_rotation) * speed * delta;
	pass


func _on_hit_box_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
		# Only deal damage if the thing is able to be damaged
			child.hit(damage)
			queue_free()
	pass # Replace with function body.
