extends Node2D

# Firing delay & hold to fire
var can_fire : bool = true
var can_fire_basic : bool = true
var mousePos
@export var defaultSpell : PackedScene
var currentSpell

@onready var sprite = $Sprite2D
@onready var spawnPoint = $Sprite2D/ProjectileSpawnPoint
@onready var animPlayer = $AnimationPlayer
@onready var wandColor = Color(102,55,189)
@onready var cooldownTimer = $CooldownTimer
@onready var basic_attack_timer = $BasicProjectileTimer

# Called when the node enters the scene tree for thes first time.
func _ready():
	reset_wand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	mousePos = get_global_mouse_position()
	
	#Flip to face the mouse
	if mousePos.x < global_position.x:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	look_at(mousePos)
	
	# Input event
	print(can_fire)
	if Input.is_action_pressed("fire_wand") and can_fire_basic: #left mouse click
		fire(defaultSpell, true)
	elif Input.is_action_pressed("fire_spell") and can_fire: #right mouse click
		fire(currentSpell)
	#if Input.is_action_just_pressed("reset_wand") and (can_fire or not cooldownTimer.is_stopped()):
	#	reset_wand()

func fire(spell: PackedScene = defaultSpell, base_fire: bool = false):
	if currentSpell != defaultSpell or base_fire:
		var bullet = spell.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = spawnPoint.global_position #sets spawnpoint at the spawnpoint node
		bullet.global_rotation = self.global_rotation

func reset_wand():
	currentSpell = defaultSpell

func _on_inventory_combo_created(_spellName, scene, newWandColor):
	#fire(currentSpell)
	currentSpell = scene
	sprite.material.set_shader_parameter("to",newWandColor)
	print(Vector4(newWandColor.r,newWandColor.b,newWandColor.g,newWandColor.a))

func startChargingAnimation():
	print("started charging animation")
	animPlayer.play("hold")
	#loop animation
	pass

# function to start the cooldown till next shot
# should be triggered along with starting the fire animation
func startCooldown(value):
	print("started cooldown")
	cooldownTimer.start(value)
	can_fire = false 
	animPlayer.play("cooldown")
	$"../TextureProgressBar".max_value = value;
	$"../TextureProgressBar".value = value;
	if value > 1:
		$CooldownSmoke.emitting = true

func startBasicCooldown():
	print("started basic cooldown")
	basic_attack_timer.start()
	can_fire_basic = false
	animPlayer.play("cooldown")

func startFireAnimation():
	print("started firing animation")
	#clear queue
	#queue fire animation into cooldown animation
	animPlayer.play("fire")
	#animplayer.queue
	
# signal function should loop the cooldown animation when it starts
func _on_animation_player_current_animation_changed(anim_name):
	if anim_name == "cooldown":
		print("started cooldown animation")

# signal function should change the wand state from cooldown to can fire and play and loop the idle animation
func _on_cooldown_timer_timeout(): 
	print("started idle animation")
	can_fire = true
	animPlayer.play("idle")
	$CooldownSmoke.emitting = false;


func _on_basic_projectile_timer_timeout():
	print("started idle animation")
	can_fire_basic = true
	animPlayer.play("idle")
