extends CanvasLayer

var player
var entity_manager : Node
var detect_range : float
var screen_width : float
var screen_height : float
var idtr_pos_x
var idtr_pos_y
const max_scale : float = 4.0

# INDICATORS ON THE MAP
@export var enemy_idtr : PackedScene
@export var item_idtr : PackedScene
var indicator_array : Array

@onready var indicator_node = $Indicators
@onready var center = $Center

# Called when the node enters the scene tree for the first time.
func _ready():
	# Screen Size Adjustments
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	
	entity_manager = owner
	player = get_tree().get_nodes_in_group("Player")[0]
	idtr_pos_x = screen_width/2 - 50
	idtr_pos_y = screen_height/2 - 50
	detect_range = screen_height*2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Display these entities on the minimap relative to the player
	move_indicators()
	display_indicators()

# Create an indicator of a specific type
func create_indicator(idtr_type : String):
	var indicator
	if idtr_type == "enemy":
		indicator = enemy_idtr.instantiate()
		indicator_node.add_child(indicator)
		indicator_array.append(indicator)
	elif idtr_type == "item":
		indicator = item_idtr.instantiate()
		indicator_node.add_child(indicator)
		indicator_array.append(indicator)

# Delete the indicator when the enemy dies or is removed
func remove_indicator(enemy: Object):
	var idtr_index = entity_manager.enemy_array.find(enemy) # get the deleted enemy's index
	if idtr_index < 0:
		return
	indicator_array[idtr_index].visible = false
	indicator_array.remove_at(idtr_index) # removes the indicator

# Moves the indicators on the minimap
func move_indicators():
	# MOVE ENEMY INDICATORS
	for indicator in indicator_array:
		# Get a normalized vector representing the indicator's position
		var idtr_dir : Vector2 = Vector2.ZERO
		var index : int = indicator_array.find(indicator)
		var enemy_pos : Vector2 = entity_manager.enemy_array[index].position
		var player_pos : Vector2 = player.position
		idtr_dir = player_pos.direction_to(enemy_pos)
		
		# Position
		indicator.position = center.position + (idtr_dir * Vector2(idtr_pos_x, idtr_pos_y))
		
		# Rotate
		var angleTo = indicator.transform.x.angle_to(idtr_dir)
		indicator.rotate(angleTo)
		
		# Scale
		var dist = player_pos.distance_to(enemy_pos)
		var scaler : float = (1/(dist * 1.2)) * 1500
		indicator.scale = Vector2(scaler, scaler)
		
	# Remove any indicators not in the array
	delete_loose_indicators()

# Controls the visibility of indicators
func display_indicators():
	var enemies = entity_manager.enemy_array
	
	# Determines whether to display an enemy's indicator 
	# or not based on the distance from the player
	for i in indicator_array.size():
		if enemies[i].position.distance_to(player.position) <= detect_range and \
		(enemies[i].position.x > player.position.x + (screen_width/2 + 50) or \
		enemies[i].position.x < player.position.x - (screen_width/2 + 50) or \
		enemies[i].position.y > player.position.y + (screen_height/2 + 50) or \
		enemies[i].position.y < player.position.y - (screen_height/2 + 50)):
			indicator_array[i].visible = true
		else:
			indicator_array[i].visible = false
	
# Mark an indicator for deletion if it isn't in the array
func delete_loose_indicators():
	for child in indicator_node.get_children():
		if !indicator_array.has(child):
			child.delete = true
