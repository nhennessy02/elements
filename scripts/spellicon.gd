extends Sprite2D

@export var inventory_slot_index: int
@onready var anim_player = $AnimationPlayer

var spell_index: int = -1
var empty_display: bool = true
var mouse_over: bool = false

# Shows the spell currently in the player's inventory slot
func display_current_spell():
	empty_display = false
	match spell_index:
		0: # Pestilence
			anim_player.play("pestilence")
			return
		1: # Hemomancy
			anim_player.play("hemomancy")
			return
		2: # Divine
			anim_player.play("divine")
			return
		3: # Bonecraft
			anim_player.play("bonecraft")
			return
		4: # Occultism
			anim_player.play("occultism")
			return
		5: # Epidemic (P+P)
			anim_player.play("default_combo")
			return
		6: # Leeching Shot (P+H)
			anim_player.play("default_combo")
			return
		7: # NAME PENDING (P+D)
			anim_player.play("default_combo")
			return
		8: # Rot (P+B)
			anim_player.play("default_combo")
			return
		9: # NAME PENDING (P+O)
			anim_player.play("default_combo")
			return
		10: # Aorta (H+H)
			anim_player.play("default_combo")
			return
		11: # Life Drain (H+D)
			anim_player.play("default_combo")
			return
		12: # Marrow (H+B)
			anim_player.play("default_combo")
			return
		13: # Blood Clot (H+O)
			anim_player.play("default_combo")
			return
		14: # NAME PENDING (D+D)
			anim_player.play("default_combo")
			return
		15: # Bone Plating (D+B)
			anim_player.play("default_combo")
			return
		16: # NAME PENDING (D+O)
			anim_player.play("default_combo")
			return
		17: # Calcification (B+B)
			anim_player.play("default_combo")
			return
		18: # Osteokinesis (B+O)
			anim_player.play("default_combo")
			return
		19: # Etherealism (O+O)
			anim_player.play("default_combo")
			return
		_: # default case
			anim_player.play("empty")
			empty_display = true

# Display an empty slot
func empty():
	anim_player.play("empty")
	empty_display = true

# MOUSE OVER
func _on_area_2d_mouse_entered():
	mouse_over = true

# MOUSE EXIT
func _on_area_2d_mouse_exited():
	mouse_over = false
