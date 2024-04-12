extends CanvasLayer
class_name UI

#ui properties
@onready var health_label = %HealthLabel
@onready var shield_label = %ShieldLabel
@onready var element_0 = %Element0
@onready var element_1 = %Element1
@onready var element_2 = %Element2
@onready var selected_0 = $Control/ElementTextureContainer/Slot0/Element0/Selected0
@onready var selected_1 = $Control/ElementTextureContainer/Slot1/Element1/Selected1
@onready var selected_2 = $Control/ElementTextureContainer/Slot2/Element2/Selected2

var spriteArray = [load("res://assets/sprites/elements/pestilence_ui.png"),load("res://assets/sprites/elements/hemomancy_ui.png"),load("res://assets/sprites/elements/convalescence_ui.png"),load("res://assets/sprites/elements/bonecraft_ui.png"),load("res://assets/sprites/elements/occultism_ui.png")]

func update_health_label(value):
	health_label.text = "Health: " + str(value)
	
func update_shield_label(value):
	shield_label.text = "Sheild: " + str(value)

func _on_player_health_changed(value):
	update_health_label(value)
	
func _on_player_shield_changed(value):
	update_shield_label(value)
	

func update_inventory_textures(value):
	match value.size():
		1:
			element_0.texture = spriteArray[value[0]]
			element_1.texture = null
			element_2.texture = null
		2:
			element_0.texture = spriteArray[value[0]]
			element_1.texture = spriteArray[value[1]]
			element_2.texture = null
		3:
			element_0.texture = spriteArray[value[0]]
			element_1.texture = spriteArray[value[1]]
			element_2.texture = spriteArray[value[2]]
		_:
			element_0.texture = null
			element_1.texture = null
			element_2.texture = null


func _on_player_inventory_changed(value):
	update_inventory_textures(value)


