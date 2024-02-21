extends CharacterBody2D

const speed = 300.0

@onready var sprite = $Sprite2D
var mousePos
@onready var animTree = $AnimationTree

func _physics_process(_delta):
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_vector("move_left", "move_right","move_up","move_down"); #Phillip - using get_vector instead of get_axis as it get all four directions
	
	if direction == Vector2.ZERO:
		animTree["parameters/conditions/idle"] = true
		animTree["parameters/conditions/running"] = false
	else:
		animTree["parameters/conditions/running"] = true
		animTree["parameters/conditions/idle"] = false
	
	# Update velocity
	velocity = direction * speed 
	
	#Get the mouse position and update flip
	mousePos = get_global_mouse_position()
	if mousePos.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	# Smoothes movement while colliding with walls, etc.
	move_and_slide()
