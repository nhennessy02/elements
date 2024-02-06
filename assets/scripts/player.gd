extends CharacterBody2D

const speed = 300.0

@onready var sprite = $Sprite2D
var mousePos

func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_vector("move_left", "move_right","move_up","move_down"); #Phillip - using get_vector instead of get_axis as it get all four directions
	
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
