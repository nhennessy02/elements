extends Node

#This script should handle
#1. loading in the json of elements and their properties into an object of some sort
#2. handle your characters inventory of up to three elements - works alright
#2a. picking up elements - works alright
#2b. swaping elements if you're already at three - works alright
#2c. dropping elements - not started
#3. handle the combination of elements and load the combo into your wand - not working
#3a. search up the correct combination from given element array - not working
#3b. create the correct object/scene - works alright
#3c. give the object/scene to the wand to use - works alright
#3d. remove the elements used from your inventory

enum Element { PESTILENCE = 0, HEMOMANCY = 1, CONVALESCENCE = 2, BONECRAFT = 3, OCCULTISM = 4}
var inventory = []
var combo = []
var groundItems = []
var pickedSlot0 : bool = false
var pickedSlot1 : bool = false
var pickedSlot2 : bool = false
@onready var pickupZone = $"../Area2D"
@onready var comboTimer = $Timer

# References to the border UI for itemUI elements
@onready var ui = $"../UI"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#handles picking up objects from the ground
	if Input.is_action_just_pressed("select"):
		itemPickup()
	#this second is about creating combinations 
	#control either through press 1 2 and or 3 then send the combo after a timer - coded this way
	#or hold a button, key or right click, press 1 2 and or 3 then release to send combo
	if Input.is_action_just_pressed("slot0") and not pickedSlot0 and inventory.size() >= 1:
		pickedSlot0 = true
	elif Input.is_action_just_pressed("slot0") and pickedSlot0 and inventory.size() >= 1:
		pickedSlot0 = false
		
	if Input.is_action_just_pressed("slot1") and not pickedSlot1 and inventory.size() >= 2:
		pickedSlot1 = true
	elif Input.is_action_just_pressed("slot1") and pickedSlot1 and inventory.size() >= 2:
		pickedSlot1 = false
		
	if Input.is_action_just_pressed("slot2") and not pickedSlot2 and inventory.size() >= 3:
		pickedSlot2 = true
	elif Input.is_action_just_pressed("slot2") and  pickedSlot2 and inventory.size() >= 3:
		pickedSlot2 = false
	
	if Input.is_action_just_pressed("load_wand"):
		if pickedSlot2:
			combo.append(inventory[2])
			inventory.remove_at(2)
		if pickedSlot1:
			combo.append(inventory[1])
			inventory.remove_at(1)
		if pickedSlot0:
			combo.append(inventory[0])
			inventory.remove_at(0)
		pickedSlot0 = false
		pickedSlot1 = false
		pickedSlot2 = false
		comboLookup(combo)
		combo = []
		inventory_changed.emit(inventory)

	ui.selected_0.visible = pickedSlot0
	ui.selected_1.visible = pickedSlot1
	ui.selected_2.visible = pickedSlot2

func comboLookup(array):
	array.sort_custom(func(a,b): return a < b)
	match array:
		[]:
			print("using basic projectile")
			combo_created.emit("Basic Projectile",load("res://prefabs/player/base_projectile.tscn"),Color(0.4,0.21,0.74))
		[Element.PESTILENCE]:
			print("using Pestilence")
			combo_created.emit("Pestilence",load("res://prefabs/player/spells/pestilence.tscn"),Color(0,0.47,0.09))
		[Element.HEMOMANCY]:
			print("using Hemomancy")
			#combo_created.emit("Hemomancy",0.25,load("res://prefabs/player/spells/hemomancy.tscn"),Color(0.58,0,0.11))
		[Element.CONVALESCENCE]:
			print("using Convalescence")
			combo_created.emit("Convalescence",load("res://prefabs/player/spells/convalescence.tscn"),Color(0.69,0.62,0.17))
		[Element.BONECRAFT]:
			print("using Bonecraft")
			combo_created.emit("Bonecraft",load("res://prefabs/player/spells/bonecraft.tscn"),Color(0.58,0.56,0.50))
		[Element.OCCULTISM]:
			print("using Occultism")
		[Element.HEMOMANCY,Element.HEMOMANCY]:
			print("using Aorta")
			combo_created.emit("Aorta",load("res://prefabs/player/spells/aorta.tscn"),Color(0.45,0,0.05))
		[Element.PESTILENCE,Element.HEMOMANCY]:
			print("using Leeching Shot")
			combo_created.emit("Leeching Shot",load("res://prefabs/player/spells/leeching_shot.tscn"),Color(0.85,0.43,0.30))
		_:
			print("couldn't decipher combo")

signal combo_created(spellName,scene,wandColor) #useRate is how often the spell is used in seconds

# this second is about picking up items
func _on_area_2d_area_entered(area):
	if area.is_in_group("Item"):
		groundItems.append(area)
		#print("Item entered")
		#print(area.get_node("Item").getId())
		#print(area)

func _on_area_2d_area_exited(area):
	if area.is_in_group("Item"):
		groundItems.erase(area)
		#print("Item exited")
		#print(area.get_node("Item").getId())
		#print(area)

func itemPickup():
	var item
	for element in groundItems:
		for node in element.get_children():
			if node is Item:
				item = node
				if inventory.size() == 3:
					var temp = item.getId()
					item.setId(inventory.pop_front())
					inventory.push_back(temp) 					
					inventory_changed.emit(inventory)
					#swap items
					# save information about the item in the inventory array
				else:
					inventory.append(item.id)
					item.pickedUp()
					inventory_changed.emit(inventory)
				break
		if item:
			break
	if not item:
		return
	#print(inventory)

signal inventory_changed(value)





