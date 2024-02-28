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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#handles picking up objects from the ground
	if Input.is_action_just_pressed("select"):
		itemPickup()
		#print("select has been pressed")
	
	#this second is about creating combinations 
	#control either through press 1 2 and or 3 then send the combo after a timer - coded this way
	#or hold a button, key or right click, press 1 2 and or 3 then release to send combo
	if Input.is_action_just_pressed("slot0") and not pickedSlot0 and inventory.size() >= 1:
		comboTimer.start()
		combo.append(inventory[0])
		pickedSlot0 = true
	if Input.is_action_just_pressed("slot1") and not pickedSlot1 and inventory.size() >= 2:
		comboTimer.start()
		combo.append(inventory[1])
		pickedSlot1 = true
	if Input.is_action_just_pressed("slot2") and not pickedSlot2 and inventory.size() >= 3:
		comboTimer.start()
		combo.append(inventory[2])
		pickedSlot2 = true
	if pickedSlot0 and pickedSlot1 and pickedSlot2:
		comboTimer.stop()
		comboLookup(combo)
		combo = []

func _on_timer_timeout():
	comboLookup(combo)
	pickedSlot0 = false
	pickedSlot1 = false
	pickedSlot2 = false
	combo = []	

func comboLookup(array):
	array.sort_custom(func(a,b): a < b)
	match array:
		[]:
			print("using Nothing")
		[Element.PESTILENCE]:
			print("using Pestilence")
			combo_created.emit("Pestilence",3,load("res://prefabs/player/spells/pestilence.tscn"))
		[Element.HEMOMANCY]:
			print("using Hemomancy")
			combo_created.emit("Hemomancy",0.25,load("res://prefabs/player/spells/hemomancy.tscn"))
		[Element.CONVALESCENCE]:
			print("using Convalescence")
		[Element.BONECRAFT]:
			print("using Bonecraft")
			combo_created.emit("Bonecraft",5,load("res://prefabs/player/spells/bonecraft.tscn"))
		[Element.OCCULTISM]:
			print("using Occultism")
		[Element.HEMOMANCY,Element.HEMOMANCY]:
			print("using Aorta")
			combo_created.emit("Aorta",7,load("res://prefabs/player/spells/aorta.tscn"))
		[Element.PESTILENCE,Element.HEMOMANCY]:
			print("using Leeching Shot")
		_:
			print("couldn't decipher combo")

signal combo_created(spellName,useRate,scene) #useRate is how often the spell is used in seconds

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





