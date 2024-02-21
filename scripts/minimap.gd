extends CanvasLayer

var entity_manager : Node
@export var range : float = 1000

# INDICATORS ON THE MAP
@export var player_idtr : PackedScene
@export var enemy_idtr : PackedScene
@export var item_idtr : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	entity_manager = owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get all entities within a certain range of the player
	get_entities_in_range(range)
	# Display these entities on the minimap relative to the player
	display_entities()

func get_entities_in_range(radius: float):
	pass

func display_entities():
	pass
