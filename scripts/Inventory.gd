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

enum Element { PESTILENCE = 0, HEMOMANCY = 1, DIVINE = 2, BONECRAFT = 3, OCCULTISM = 4}
var inventory: Array[Array]
var combo: Array
var groundItems = []
var slots: Array[bool] = [false, false, false]

@onready var pickupZone = $"../Area2D"
@onready var comboTimer = $Timer

# References to the border UI for itemUI elements
@onready var ui = $"../UI"
var inventory_loaded: bool = false

func _ready():
#	inventory = [Element.DIVINE]
#	inventory_changed.emit(inventory)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# LOADS INVENTORY FROM PREVIOUS SCENES
	if !inventory_loaded:
		get_inventory()
		inventory_loaded = true
	
	#handles picking up objects from the ground
	if Input.is_action_just_pressed("select"):
		itemPickup()
	
	# Have only 1 spell selected at a time
	if Input.is_action_just_pressed("slot0") and inventory.size() >= 1:
		set_active_spell(0)
	elif Input.is_action_just_pressed("slot1") and inventory.size() >= 2:
		set_active_spell(1)
	elif Input.is_action_just_pressed("slot2")and inventory.size() >= 3:
		set_active_spell(2)
	
	# Toggle between spells by pressing SHIFT or TAB
	if (Input.is_action_just_pressed("toggle_spell") or Input.is_action_just_pressed("mouse_wheel_down")) and inventory.size() > 0:
		var active_spell_index: int
		for i in inventory.size():
			if slots[i] == true:
				active_spell_index = i
				break
		set_active_spell((active_spell_index + 1) % inventory.size())
	
	# Selecting Spells with Mousewheel
	if Input.is_action_just_pressed("mouse_wheel_up") and inventory.size() > 0:
		var active_spell_index: int
		for i in inventory.size():
			if slots[i] == true:
				active_spell_index = i
				break
		active_spell_index -= 1
		if active_spell_index < 0:
			active_spell_index = inventory.size() - 1
		set_active_spell(active_spell_index)
	
	# Loads active spell into wand
	if Input.is_action_just_pressed("load_wand"):
		if slots[2]:
			combo = inventory[2]
			#inventory.remove_at(2)
		if slots[1]:
			combo = inventory[1]
			#inventory.remove_at(1)
		if slots[0]:
			combo = inventory[0]
			#inventory.remove_at(0)
		comboLookup(combo)
		combo = []
		#inventory_changed.emit(inventory)

	ui.selected_0.visible = slots[0]
	ui.selected_1.visible = slots[1]
	ui.selected_2.visible = slots[2]
	save_inventory()

# Sets the chosen slot to active and all other to not be
func set_active_spell(index: int):
	for i in slots.size():
		if i == index:
			slots[i] = true
		else:
			slots[i] = false

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
			combo_created.emit("Hemomancy",load("res://prefabs/player/spells/hemomancy.tscn"),Color(0.58,0,0.11))
		[Element.DIVINE]:
			print("using Convalescence")
			combo_created.emit("Convalescence",load("res://prefabs/player/spells/convalescence.tscn"),Color(0.69,0.62,0.17))
		[Element.BONECRAFT]:
			print("using Bonecraft")
			combo_created.emit("Bonecraft",load("res://prefabs/player/spells/bonecraft.tscn"),Color(0.58,0.56,0.50))
		[Element.OCCULTISM]:
			print("using Occultism")
			combo_created.emit("Occultism",load("res://prefabs/player/spells/occultism.tscn"),Color(0.38,0.08,0.61))
		[Element.PESTILENCE,Element.PESTILENCE]:
			print("using Epidemic")
			combo_created.emit("Epidemic",load("res://prefabs/player/spells/epidemic.tscn"),Color(0.02,0.77,0.12))
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

# Pick up an item from the environment
func itemPickup():
	var item
	for element in groundItems:
		for node in element.get_children():
			if node is Item:
				item = node
				if inventory.size() == 3:
					var temp = item.getId()
					item.setId(get_combo_index(inventory.pop_front()))
					inventory.push_back([temp])
					inventory_changed.emit(inventory)
					#swap items
					# save information about the item in the inventory array
				else:
					inventory.append([item.id])
					item.pickedUp()
					inventory_changed.emit(inventory)
				break
		if item:
			break
	if not item:
		return
	#print(inventory)

# Adds a spell to the inventory
func add_item(spell: Array):
	if inventory.size() < 3:
		spell.sort_custom(func(a,b): return a < b)
		inventory.append(spell)
		inventory_changed.emit(inventory)

signal inventory_changed(value)

# There is an index which corresponds to each item combination
func get_combo_index(item_array: Array):
	item_array.sort_custom(func(a,b): return a < b)
	match item_array:
		[]: # empty case
			return -1
		[Element.PESTILENCE]:
			return 0
		[Element.HEMOMANCY]:
			return 1
		[Element.DIVINE]:
			return 2
		[Element.BONECRAFT]:
			return 3
		[Element.OCCULTISM]:
			return 4
		[Element.PESTILENCE, Element.PESTILENCE]:
			return 5
		[Element.PESTILENCE,Element.HEMOMANCY]:
			return 6
		[Element.PESTILENCE, Element.DIVINE]:
			return 7
		[Element.PESTILENCE, Element.BONECRAFT]:
			return 8
		[Element.PESTILENCE, Element.OCCULTISM]:
			return 9
		[Element.HEMOMANCY,Element.HEMOMANCY]:
			return 10
		[Element.HEMOMANCY, Element.DIVINE]:
			return 11
		[Element.HEMOMANCY, Element.BONECRAFT]:
			return 12
		[Element.HEMOMANCY, Element.OCCULTISM]:
			return 13
		[Element.DIVINE, Element.DIVINE]:
			return 14
		[Element.DIVINE, Element.BONECRAFT]:
			return 15
		[Element.DIVINE, Element.OCCULTISM]:
			return 16
		[Element.BONECRAFT, Element.BONECRAFT]:
			return 17
		[Element.BONECRAFT, Element.OCCULTISM]:
			return 18
		[Element.OCCULTISM, Element.OCCULTISM]:
			return 19
		_: # default case
			return -1

# returns an array based on the index given
func get_combo_from_index(index: int):
	match index:
		0:
			return [Element.PESTILENCE]
		1:
			return [Element.HEMOMANCY]
		2:
			return [Element.DIVINE]
		3:
			return [Element.BONECRAFT]
		4:
			return [Element.OCCULTISM]
		5:
			return [Element.PESTILENCE, Element.PESTILENCE]
		6:
			return [Element.PESTILENCE, Element.HEMOMANCY]
		7:
			return [Element.PESTILENCE, Element.DIVINE]
		8:
			return [Element.PESTILENCE, Element.BONECRAFT]
		9:
			return [Element.PESTILENCE, Element.OCCULTISM]
		10:
			return [Element.HEMOMANCY, Element.HEMOMANCY]
		11:
			return [Element.HEMOMANCY, Element.DIVINE]
		12:
			return [Element.HEMOMANCY, Element.BONECRAFT]
		13:
			return [Element.HEMOMANCY, Element.OCCULTISM]
		14:
			return [Element.DIVINE, Element.DIVINE]
		15:
			return [Element.DIVINE, Element.BONECRAFT]
		16:
			return [Element.DIVINE, Element.OCCULTISM]
		17:
			return [Element.BONECRAFT, Element.BONECRAFT]
		18:
			return [Element.BONECRAFT, Element.OCCULTISM]
		19:
			return [Element.OCCULTISM, Element.OCCULTISM]
		_: # default case
			return []

# saves and retrieves the inventory to an autoload
func save_inventory():
	PlayerInventory.inventory = inventory
func get_inventory():
	inventory = PlayerInventory.inventory
	inventory_changed.emit(inventory)
