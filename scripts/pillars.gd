extends Node2D

var player
var items
var prev_inventory_size: int
var item_collected: bool = false

var pillars : Array[CharacterBody2D]
var pillar_indexes : Array[int]
@export var pillar_scene : PackedScene
@export var pillar_pos_array : Array[Vector2]

@onready var teleporter = $"../NextWaveSigil"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get player reference
	if get_tree().get_nodes_in_group("Player")[0] != null:
		player = get_tree().get_nodes_in_group("Player")[0]
		items = player.get_node("Inventory")
	setup_pillars()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Change Z-index depending on player pos to look nicer
	if player != null:
		for pillar in pillars:
			if player.global_position.y < pillar.global_position.y:
				pillar.z_index = 2
			else:
				pillar.z_index = 0

func setup_pillars():
	var pillar_count = randi_range(2,3)
	# Spawn Pillars with Items
	for i in pillar_count:
		var new_pillar = pillar_scene.instantiate()
		pillar_indexes.push_back(get_pillar_index())
		new_pillar.get_node("BaseItem").get_node("Item").id = pillar_indexes[i]
		add_child(new_pillar)
		pillars.push_back(new_pillar)
		pillars[i].position = pillar_pos_array[i]

# Get an index so that no two spells are the same
func get_pillar_index(min_index: int = 0, max_index: int = 4):
	var index: int = randi_range(min_index,max_index)
	var matching: bool = false
	for i in pillar_indexes.size():
		if index == pillar_indexes[i]:
			matching = true
	
	# Recur if matching item index
	if matching:
		return get_pillar_index()
	else:
		return index

# Clears spell items when the player picks up one
func delete_all_items():
	for pillar in pillars:
		for child in pillar.get_children():
			child.queue_free()
	
	# Stop from calling again
	item_collected = true
	
	# Player can now leave to next wave
	activate_teleporter()

# Allows the player to leave the subarea
func activate_teleporter():
	teleporter.activated = true
