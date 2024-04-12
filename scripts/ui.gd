extends CanvasLayer
class_name UI

#ui properties
@onready var health_label = %HealthLabel
@onready var shield_label = %ShieldLabel
@onready var element_0 = %Element0
@onready var element_1 = %Element1
@onready var element_2 = %Element2
var elements: Array[TextureRect]

@onready var selected_0 = $Control/ElementTextureContainer/Slot0/Element0/Selected0
@onready var selected_1 = $Control/ElementTextureContainer/Slot1/Element1/Selected1
@onready var selected_2 = $Control/ElementTextureContainer/Slot2/Element2/Selected2

enum Element { PESTILENCE = 0, HEMOMANCY = 1, DIVINE = 2, BONECRAFT = 3, OCCULTISM = 4}
#var spriteArray = [load("res://assets/sprites/elements/pestilence_ui.png"),load("res://assets/sprites/elements/hemomancy_ui.png"),load("res://assets/sprites/elements/convalescence_ui.png"),load("res://assets/sprites/elements/bonecraft_ui.png"),load("res://assets/sprites/elements/occultism_ui.png"),load("res://assets/sprites/elements/defaultcombo_ui.png")]
@export var sprites: Array[Texture2D]
@export var default_ui_sprite: Texture2D

func _ready():
	elements.push_back(element_0)
	elements.push_back(element_1)
	elements.push_back(element_2)

func update_health_label(value):
	health_label.text = "Health: " + str(value)
	
func update_shield_label(value):
	shield_label.text = "Sheild: " + str(value)

func _on_player_health_changed(value):
	update_health_label(value)
	
func _on_player_shield_changed(value):
	update_shield_label(value)
	

# value = inventory
func update_inventory_textures(value):
	for i in value.size():
		match value[i]:
			[]: # empty inventory slot
				elements[i].texture = null
			[Element.PESTILENCE]:
				elements[i].texture = sprites[0]
			[Element.HEMOMANCY]:
				elements[i].texture = sprites[1]
			[Element.DIVINE]:
				elements[i].texture = sprites[2]
			[Element.BONECRAFT]:
				elements[i].texture = sprites[3]
			[Element.OCCULTISM]:
				elements[i].texture = sprites[4]
			
			[Element.PESTILENCE,Element.HEMOMANCY]: # LEECHING SHOT
				elements[i].texture = sprites[6]
			
			[Element.HEMOMANCY,Element.HEMOMANCY]: # AORTA
				elements[i].texture = sprites[10]
			
			_: # default case
				elements[i].texture = default_ui_sprite
	
	# Dispose of unused textures
	if value.size() <= 1:
		elements[1].texture = null
	if value.size() <= 2:
		elements[2].texture = null

func _on_player_inventory_changed(value):
	update_inventory_textures(value)


