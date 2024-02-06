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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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

			
