extends Node2D

@onready var SearchArea = $SearchArea
@onready var CollisionShape = $SearchArea/CollisionShape2D

@export var speed : float = 300
var maxSpeed : float = 700
var ratio : float = 0.2
@export var damage : int = 3
@export var cooldown : float = 0.5
var wand
var nearestChild
var angleUpdateCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	wand = get_node("../Player/Wand")
	wand.startFireAnimation()
	wand.startCooldown(cooldown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#finding which enemy 
	if(not nearestChild):
		var minDist = Constants.MAX_FLOAT
		for child in SearchArea.get_overlapping_bodies():
			if position.distance_to(child.global_position) < minDist:
				minDist = position.distance_to(child.global_position)
				nearestChild = child
	
	#finding out if enemy is to the left or right of the trajectory
	if(not is_instance_valid(nearestChild)):
		nearestChild = null
	
	if(nearestChild):
		if(angleUpdateCounter >= 2): #every 2 frames update the angle and the speed of the projectile
			var angleBetween = Vector2.from_angle(global_rotation).angle_to(nearestChild.global_position - global_position)
			global_rotation = global_rotation + angleBetween * ratio
			speed = speed + (maxSpeed - speed) * ratio
			angleUpdateCounter = 0
		angleUpdateCounter += 1
	
	#turn left
	#if(perpVectorToEnemy.dot(headingVector)>0):
		
	#else(perpVectorToEnemy.dot(headingVector)<0):
	#updating position 
	position = position + Vector2.from_angle(global_rotation) * speed * delta;
	pass


func _on_hit_box_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
		# Only deal damage if the thing is able to be damaged
			child.hit(damage)
			queue_free()
	pass # Replace with function body.
