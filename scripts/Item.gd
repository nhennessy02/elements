extends Node

class_name Item
enum Element { PESTILENCE = 0, HEMOMANCY = 1, CONVALESCENCE = 2, BONECRAFT = 3, OCCULTISM = 4}
@export var id : int = -1

@onready var sprite = $"../Sprite2D"
#get some sprites only pestilence and hemomancy have temporary sprites
var spriteArray = [load("res://assets/sprites/elements/pestilence_bubble.png"),load("res://assets/sprites/elements/hemomancy_bubble.png"),load("res://assets/sprites/elements/convalescence_bubble.png"),load("res://assets/sprites/elements/bonecraft_bubble.png"),load("res://assets/sprites/elements/occultism_bubble.png")]

# Called when the node enters the scene tree for the first time.
func _ready():
	if id == -1:
		id = randi_range(Element.PESTILENCE, Element.OCCULTISM)
	#updateColor()
	updateSprite()

func setId(value):
	id = value
	#updateColor()
	updateSprite()
	
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
			

func updateSprite():
	sprite.texture = spriteArray[id]
			
func pickedUp():
	get_parent().queue_free()
