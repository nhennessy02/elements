extends Sprite2D

@onready var anim_player = $AnimationPlayer
var activated: bool = false
var can_teleport: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if activated:
		anim_player.play("activated")
	else:
		anim_player.play("deactivated")
	
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
