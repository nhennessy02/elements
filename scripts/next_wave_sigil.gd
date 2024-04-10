extends Sprite2D

@onready var particles = $Particles
@onready var anim_player = $AnimationPlayer
var activated: bool = false
var can_teleport: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if activated:
		anim_player.play("activated")
		particles.emitting = true
	else:
		anim_player.play("deactivated")
		particles.emitting = false
	
	# Update particles while on sigil
	if can_teleport:
		particles.orbit_velocity_min = -0.2
		particles.orbit_velocity_max = 0.2
	else:
		particles.orbit_velocity_min = -0.1
		particles.orbit_velocity_max = 0.1
	
	# Send player to next wave
	if can_teleport and activated and Input.is_action_just_pressed("select"):
		get_tree().quit()

# When the player enters the sigil it turns on a bool
# While this bool is true the player can use an input to progress to the next wave
func _on_area_2d_body_entered(body):
	for child in body.get_children():
		if child is DamageablePlayer:
			can_teleport = true

# Turn off the teleport when the player leaves
func _on_area_2d_body_exited(body):
	for child in body.get_children():
		if child is DamageablePlayer:
			can_teleport = false
