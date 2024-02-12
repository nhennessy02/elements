extends Node

class_name Item
enum Element { PESTILENCE = 1, HEMOMANCY = 2, CONVALESCENCE = 3, BONECRAFT = 4, OCCULTISM = 5}
var id;

@onready var sprite = $"../Sprite2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	id = randi_range(Element.PESTILENCE, Element.OCCULTISM)
	updateColor()

func setId(value):
	id = value
	updateColor()
	
func getId():
	return id

func updateColor(): #this will need to be changed/updated for when we switch to sprites
	match id:
		Element.PESTILENCE:
			sprite.modulate = Color8(99, 255, 64)
		Element.HEMOMANCY:
			sprite.modulate = Color8(145, 13, 1)
		Element.CONVALESCENCE:
			sprite.modulate = Color8(247, 221, 89)
		Element.BONECRAFT:
			sprite.modulate = Color8(219, 213, 180)
		Element.OCCULTISM:
			sprite.modulate = Color8(126, 60, 207)
			

func pickedUp():
	get_parent().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
