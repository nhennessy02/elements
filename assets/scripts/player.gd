extends CharacterBody2D


const SPEED = 300.0

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right","ui_up","ui_down"); #Phillip - using get_vector instead of get_axis as it get all four directions
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity = direction * SPEED 
		
	move_and_slide()
