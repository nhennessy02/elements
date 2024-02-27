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
	else:
		can_fire = false
	
	# Input event
	if Input.is_action_pressed("fire_wand") and can_fire: #left mouse click
		fire()



func fire():
	
	# reset timer
	fire_timer = 0
	
	#play animation
	animPlayer.play("fire")
	
	var spell = currentSpell.instantiate()
	get_tree().current_scene.add_child(spell)
	spell.global_position = spawnPoint.global_position #sets spawnpoint at the spawnpoint node
	spell.global_rotation = self.global_rotation
	print("wand rotation:")
	print(rotation_degrees)
	
	


func _on_inventory_combo_created(spellName, useRate, scene):
	currentSpell = scene
	fire_rate = useRate
