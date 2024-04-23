extends Sprite2D

@onready var particles = $Particles
@onready var anim_player = $AnimationPlayer
@onready var pillars = $"../Pillars"
var holding_space: bool = false
var can_teleport: bool = false

# Timer
@onready var timer = $Timer
var time: float = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if holding_space and can_teleport:
		particles.emitting = true
		particles.orbit_velocity_min = -(time - timer.time_left)
		particles.orbit_velocity_max = time - timer.time_left
	else:
		particles.emitting = false
		particles.orbit_velocity_min += 0.01
		particles.orbit_velocity_max -= 0.01
	
	# Send player to next wave
	#if can_teleport and activated and Input.is_action_just_pressed("select"):
	if can_teleport and Input.is_action_just_pressed("select"):
		anim_player.play("charging")
		holding_space = true
		timer.start(time)
	elif Input.is_action_just_released("select"):
		anim_player.play("glowing")
		holding_space = false
		timer.stop()
		timer.set_wait_time(time)

# When the player enters the sigil it turns on a bool
# While this bool is true the player can use an input to progress to the next wave
func _on_area_2d_body_entered(body):
	anim_player.play("glowing")
	for child in body.get_children():
		if child is DamageablePlayer:
			can_teleport = true

# Turn off the teleport when the player leaves
func _on_area_2d_body_exited(body):
	anim_player.play("deactivated")
	for child in body.get_children():
		if child is DamageablePlayer:
			can_teleport = false

# When timer reaches 0 teleport player
func _on_timer_timeout():
	if can_teleport:
		get_tree().change_scene_to_file.call_deferred("res://scenes/game.tscn")
