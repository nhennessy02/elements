extends Node

#This script should handle
#1. loading in the json of elements and their properties into an object of some sort
#2. handle your characters inventory of up to three elements
#2a. picking up elements
#2b. swaping elements if you're already at three
#2c. dropping elements
#3. handle the combination of elements and load the combo into your wand
#3a. search up the correct combination from given element array
#3b. create the correct object/scene
#3c. give the object/scene to the wand to use

enum Element { PESTILENCE = 1, HEMOMANCY = 2, CONVALESCENCE = 3, BONECRAFT = 4, OCCULTISM = 5}
var inventory = []
@onready var pickupZone = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("select"):
	#	print("select has been pressed")
	#	itemPickup()
	pass
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("select"):
		print("select has been pressed")
		itemPickup()
	
	
	#make an array that stores what items are under the player add and remove them with the on body/area entered and exited and use that array in item pick up
func _on_area_2d_area_entered(area):
	print("area entered")
	print(area)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		return
	print("Item entered")
	print(body)


func itemPickup():
	var areas = pickupZone.get_overlapping_areas()
	print(areas)
	var item = ""
	for child in areas:
		for node in child.get_children(): #is_in_group
			if node is Item:
				item = node
			break
		break
	if item == "":
		return
	#item.pickedUp();

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
