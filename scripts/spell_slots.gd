extends Node2D

var inventory
var inv_funcs
@export var slots: Array[Sprite2D]
@export var combo_slots: Array[Sprite2D]

@onready var ui = $"../../.."

# Buttons
@onready var button = $"../../CombineUI/TextureButton"
@onready var exit_btn = $"../../ExitButton"

var loaded: bool = false

func _process(_delta):
	# Get a reference to the player's inventory
	if !loaded:
		if get_tree().get_nodes_in_group("Player")[0]:
			var player = get_tree().get_nodes_in_group("Player")[0]
			inv_funcs = player.get_node("Inventory")
			inventory = player.get_node("Inventory").inventory
		loaded = true
	
	# Click on a spell to place it in an empty slot of the combiner
	for slot in slots:
		if slot.mouse_over and !slot.empty_display and Input.is_action_just_pressed("grab_spell"):
			input_spell(slot.inventory_slot_index)
	
	# Click on a spell in the combiner to return it to its inventory slot
	for slot in combo_slots:
		if slot.mouse_over and !slot.empty_display and Input.is_action_just_pressed("grab_spell"):
			slot.empty()
			return_to_empty_slot(slot.inventory_slot_index)
			slot.inventory_slot_index = -1
	
	# Turn on Combine button if both slots full
	if !combo_slots[0].empty_display and !combo_slots[1].empty_display \
	and inv_funcs.get_combo_index([combo_slots[0].spell_index, combo_slots[1].spell_index]) >= 0:
		button.disabled = false
	else:
		button.disabled = true

# Updates the UI based on player inventory
func update_ui():
	# Assign starting spell for each slot based on inventory
	for i in inventory.size():
		slots[i].spell_index = inv_funcs.get_combo_index(inventory[i])
		slots[i].display_current_spell()

# Inputs a spell into one of the 2 combo slots
func input_spell(slot_index: int):
	# Don't input if both combo slots are full
	if combo_slots[0].empty_display or combo_slots[1].empty_display:
		# Clears the clicked slot's display
		slots[slot_index].empty()
	
		# Places spell in an empty combo slot
		for slot in combo_slots:
			if slot.empty_display:
				slot.spell_index = slots[slot_index].spell_index
				slot.inventory_slot_index = slots[slot_index].inventory_slot_index
				slot.display_current_spell()
				return

# Returns a spell to its inventory slot
func return_to_empty_slot(index: int = -1):	
	# Find empty if no index given
	if index == -1:
		for slot in slots:
			if slot.empty_display:
				slot.display_current_spell()
				return
	
	else:
		# Return spell to its specific inventory slot
		slots[index].display_current_spell()

# Combine Button Pressed
func _on_texture_button_pressed():
	var spell_i1: int = -1
	var spell_i2: int = -1
	var save_index = null
	
	# Save data
	spell_i1 = combo_slots[0].spell_index
	spell_i2 = combo_slots[1].spell_index
	
	for slot in slots:
		if !slot.empty_display:
			save_index = slot.spell_index
			break
	
	# Clear data
	for slot in combo_slots:
		# Clear old spell data from inventory
		slots[slot.inventory_slot_index].inventory_slot_index = -1
		slots[slot.inventory_slot_index].empty()
		# Clear data from combo slots
		slot.inventory_slot_index = -1
		# Empty combo display
		slot.empty()
	
	# REMOVES USED ITEMS FROM PLAYER INVENTORY
	inventory.clear()
	if save_index != null:
		inv_funcs.add_item(inv_funcs.get_combo_from_index(save_index))
	
	# Add new spell to inventory
	inv_funcs.add_item([spell_i1, spell_i2])
	
	# Display new spell in UI
	var count = 0
	for slot in slots:
		if slot.empty_display and slot.inventory_slot_index == -1:
			slot.spell_index = inv_funcs.get_combo_index([spell_i1, spell_i2])
			slot.display_current_spell()
			slot.inventory_slot_index = count
			break
		count += 1

# Exit the Combination Altar UI
func _on_exit_button_pressed():
	ui.visible = false
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.get_node("UI").visible = true
