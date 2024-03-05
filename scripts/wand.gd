extends Node2D

# Firing delay & hold to fire
@export var fire_rate : float = 0.4 
var fire_timer : float = 0
var can_fire : bool = true
var mousePos
@export var defaultSpell : PackedScene
var currentSpell

@onready var sprite = $Sprite2D
@onready var spawnPoint = $Sprite2D/ProjectileSpawnPoint
@onready var animPlayer = $AnimationPlayer
@onready var wandColor = Color(102,55,189)

# Called when the node enters the scene tree for thes first time.
func _ready():
	currentSpell = defaultSpell

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mousePos = get_global_mouse_position()
	
	#Flip to face the mouse
	if mousePos.x < global_position.x:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	look_at(mousePos)
	
	# Firing Cooldown
	fire_timer += delta
	if fire_timer >= fire_rate:
		can_fire = true
		animPlayer.play("idle")
		$CooldownSmoke.emitting = false
	else:
		can_fire = false
	
	# Input event
	if Input.is_action_pressed("fire_wand") and can_fire: #left mouse click
		fire()
		$CooldownSmoke.emitting = false
	if animPlayer.get_current_animation() != "fire":
		if !can_fire:
			animPlayer.play("cooldown")
			$CooldownSmoke.emitting = true # cooldown particle effect
		#else:
			#animPlayer.play("idle")
			
	



func fire():
	
	# reset timer
	fire_timer = 0
	
	#play animation
	animPlayer.play("fire")
	
	var spell = currentSpell.instantiate()
	get_tree().current_scene.add_child(spell)
	spell.global_position = spawnPoint.global_position #sets spawnpoint at the spawnpoint node
	spell.global_rotation = self.global_rotation


func _on_inventory_combo_created(spellName, useRate, scene, wandColor):
	currentSpell = scene
	fire_rate = useRate
	sprite.material.set_shader_parameter("to",wandColor)
	print(Vector4(wandColor.r,wandColor.b,wandColor.g,wandColor.a))
