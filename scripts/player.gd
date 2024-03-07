extends CharacterBody2D

const speed : float = 300.0
const max_speed : Vector2 = Vector2(400,400)

var direction

@onready var sprite = $Sprite2D
var mousePos

# Animation Nodes
@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree

# Timers
@export var invuln_time : float = 0.8
var invuln_timer : float = 0
@export var invuln_flicker_time : float = 0.125
var invuln_flicker_timer : float = 0
var invulnerable : bool = false
var modulate_on : bool = false

# Knockback
@export var kb_time : float = 0.8
var kb_timer : float = 0
var knockingback : bool = false
const kb_speed : float = 400.0
var current_kb_speed : float
var kb_dir : Vector2 = Vector2.ZERO

func _ready():
	current_kb_speed = kb_speed

func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("move_left", "move_right","move_up","move_down"); #Phillip - using get_vector instead of get_axis as it get all four directions
	
	# Animation Logic
	if !invulnerable:
		if direction == Vector2.ZERO:
			anim_player.play("idle")
		else:
			anim_player.play("run")
	
	# Invulnerability Timer
	if invulnerable and invuln_timer < invuln_time:
		invuln_timer += delta
	else: # invuln ends
		invulnerable = false
		invuln_timer = 0
	
	# Knockback Timer
	if knockingback and kb_timer < kb_time:
		kb_timer += delta
	else:
		knockingback = false
		kb_timer = 0
	
	var new_velocity : Vector2 = Vector2.ZERO
	
	# normal movement
	if !knockingback:
		new_velocity = direction * speed 
	
	# knockback
	if knockingback:		
		if kb_timer > kb_time/2:
			new_velocity = direction * speed # allow movement to adjust while knocked back
		new_velocity += kb_dir * current_kb_speed 
		kb_dir = (kb_dir * 20 + direction).normalized()
		if current_kb_speed >= 0 and current_kb_speed - 5 > 0:
			current_kb_speed -= 5
		
		# show invuln
		if invuln_flicker_timer <= invuln_flicker_time:
			invuln_flicker_timer += delta
		else: # reset timer
			modulate_on = !modulate_on
			invuln_flicker_timer = 0
		
	else: 
		modulate_on = false
		current_kb_speed = kb_speed
	
	if modulate_on:
		sprite.modulate = "bd002f"
	else:
		sprite.modulate = "ffffff"
	
	# Update velocity
	velocity = new_velocity.clamp(-max_speed, max_speed)
	
	#Get the mouse position and update flip
	mousePos = get_global_mouse_position()
	if mousePos.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	# Smoothes movement while colliding with walls, etc.
	move_and_slide()

#outgoing signals
signal health_changed(value : int)
func _on_health_tracker_health_changed(value):
	health_changed.emit(value)

signal inventory_changed(value)
func _on_inventory_inventory_changed(value):
	inventory_changed.emit(value)
