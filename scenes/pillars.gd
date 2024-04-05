extends Node2D

var player
var items
var prev_inventory_size: int

var pillars : Array[CharacterBody2D]
var pillar_indexes : Array[int]
@export var pillar_scene : PackedScene
@export var pillar_pos_array : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get player reference
	if get_tree().get_nodes_in_group("Player")[0] != null:
		player = get_tree().get_nodes_in_group("Player")[0]
		items = player.get_node("Inventory")
	
	var pillar_count = randi_range(2,3)
	
	# Spawn Pillars with Items
	for i in pillar_count:
		var new_pillar = pillar_scene.instantiate()
		pillar_indexes.push_back(get_pillar_index())
		new_pillar.get_node("BaseItem").get_node("Item").id = pillar_indexes[i]
		add_child(new_pillar)
		pillars.push_back(new_pillar)
		pillars[i].position = pillar_pos_array[i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Delete other items when one is picked up
	var current_inventory_size = items.inventory.size()
	if current_inventory_size != prev_inventory_size:
		delete_all_items()
	prev_inventory_size = current_inventory_size
	
	# Change Z-index depending on player pos to look nicer
	if player != null:
		for pillar in pillars:
			if player.global_position.y < pillar.global_position.y:
				pillar.z_index = 2
			else:
				pillar.z_index = 0

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

func delete_all_items():
	pass
