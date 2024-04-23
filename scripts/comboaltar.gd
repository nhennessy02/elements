extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var particles = $CPUParticles2D
@onready var ui = $"../CombinerUI"
@onready var anim_player = $AnimationPlayer
var ui_script: Node2D

var player

var interactable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get player reference
	if get_tree().get_nodes_in_group("Player")[0] != null:
		player = get_tree().get_nodes_in_group("Player")[0]
	
	ui_script = ui.get_node("Background/InventoryUI/SpellSlots")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Change Z-index depending on player pos to look nicer
	if player != null:
		if player.global_position.y < sprite.global_position.y:
			sprite.z_index = 2
		else:
			sprite.z_index = 0
	
	# Interact Inputs
	if interactable and Input.is_action_just_pressed("select"):
		player.get_node("UI").visible = false
		ui.visible = true
		ui_script.update_ui()
	
	# Visuals while interactable
	if interactable:
		particles.emitting = true
	else:
		particles.emitting = false

# Check for when the player enters the altar's range
func _on_area_2d_body_entered(body):
	anim_player.play("glowing")
	for child in body.get_children():
		if child is DamageablePlayer:
			interactable = true

# Check for when the player leaves the altar's range
func _on_area_2d_body_exited(body):
	anim_player.play("static")
	for child in body.get_children():
		if child is DamageablePlayer:
			interactable = false
