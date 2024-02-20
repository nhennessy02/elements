extends Node

#This script should handle
#1. loading in the json of elements and their properties into an object of some sort
#2. handle your characters inventory of up to three elements - works alright
#2a. picking up elements - works alright
#2b. swaping elements if you're already at three - works alright
#2c. dropping elements - not started
#3. handle the combination of elements and load the combo into your wand - not working
#3a. search up the correct combination from given element array - not working
#3b. create the correct object/scene - not started
#3c. give the object/scene to the wand to use - not started

enum Element { PESTILENCE = 0, HEMOMANCY = 1, CONVALESCENCE = 2, BONECRAFT = 3, OCCULTISM = 4}
var inventory = []
var groundItems = []
@onready var pickupZone = $"../Area2D"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("select"):
		print("select has been pressed")
		itemPickup()

	#make an array that stores what items are under the player add and remove them with the on body/area entered and exited and use that array in item pick up

func _on_area_2d_area_entered(area):
	if area.is_in_group("Item"):
		groundItems.append(area)
		print("Item entered")
		print(area.get_node("Item").getId())
		print(area)

func _on_area_2d_area_exited(area):
	if area.is_in_group("Item"):
		groundItems.erase(area)
		print("Item exited")
		print(area.get_node("Item").getId())
		print(area)

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
	print(inventory)

func comboLookup(array):
	array.sort_custom(func(a,b): a < b)
	match array:
		[]:
			print("using Nothing")
		[Element.PESTILENCE]:
			print("using Pestilence")
		[Element.HEMOMANCY]:
			print("using Hemomancy")
		[Element.CONVALESCENCE]:
			print("using Convalescence")
		[Element.BONECRAFT]:
			print("using Bonecraft")
		[Element.OCCULTISM]:
			print("using Occultism")

signal inventory_changed(value)



