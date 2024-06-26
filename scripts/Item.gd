extends Node

class_name Item
enum Element { PESTILENCE = 0, HEMOMANCY = 1, CONVALESCENCE = 2, BONECRAFT = 3, OCCULTISM = 4}
@export var id : int = -1

@onready var sprite = $"../Sprite2D"
#get some sprites only pestilence and hemomancy have temporary sprites
@export var spriteArray: Array[Texture2D]
@export var default_item_sprite: Texture2D

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
		_: # default case
			sprite.modulate = Color8(255, 255, 255)

func updateSprite(): # ADD ABILITY TO DROP COMBOS
	if sprite != null and id < spriteArray.size():
		sprite.texture = spriteArray[id]
	elif sprite != null:
		sprite.texture = default_item_sprite

func pickedUp():
	get_parent().get_parent().consumed = true
	get_parent().queue_free()
