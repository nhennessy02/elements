extends Node2D

var player
var pillars : Array[CharacterBody2D]
@export var pillar_scene : PackedScene
@export var pillar_pos_array : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get player reference
	if get_tree().get_nodes_in_group("Player")[0] != null:
		player = get_tree().get_nodes_in_group("Player")[0]
	
	# Spawn pillars
	var pillar_count = randi_range(2,3)
	for i in pillar_count:
		var new_pillar = pillar_scene.instantiate()
		add_child(new_pillar)
		pillars.push_back(new_pillar)
		pillars[i].position = pillar_pos_array[i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		for pillar in pillars:
			if player.position.y < pillar.position.y:
				pillar.z_index = 2
			else:
				pillar.z_index = 0
