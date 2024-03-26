extends Node

# Effect should probably be consistent by name for example speed always increases character speed by a fixed amount
# Speed increases the character speed by 100
# Bleed hurts for 1 damage a second for 10 seconds
class_name Effect
#enum {SPEED,BLEED,REGEN,SLOW,GHOSTING,INVULNERABILITY}

@onready var durationTimer = $DurationTimer
@onready var procTimer = $ProcTimer
var attachedNode
var duration
var effect
var effectIcons = [0,load("res://assets/sprites/effects/bleeding.png")]
var iconContainer
var icon
# Called when the node enters the scene tree for the first time.
func _ready():
	iconContainer = get_node("../EffectIconContainer")
	print(iconContainer)
	icon = TextureRect.new()
	icon.texture = effectIcons[1]
	iconContainer.add_child(icon)
	# applying effect to entity
	durationTimer.start(duration)
	match effect:
		Effects.SPEED:
			#character speed += value
			pass
		Effects.BLEED:
			get_parent().get_child(3).hit(1) #this has to be rewritten to work for anything and not just a damageable node in the 4th position of the node tree
			procTimer.start(1)
		Effects.REGEN:
			pass
		Effects.SLOW:
			pass
		Effects.GHOSTING:
			pass
		Effects.INVULNERABILITY:
			pass
	#await durationTimer.timeout
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match effect:
		Effects.SPEED:
			pass
		Effects.BLEED:
			pass
		Effects.REGEN:
			pass
		Effects.SLOW:
			pass
		Effects.GHOSTING:
			pass
		Effects.INVULNERABILITY:
			pass
	pass


func _on_proc_timer_timeout():
	match effect:
		Effects.SPEED:
			pass
		Effects.BLEED:
			get_parent().get_child(3).hit(1) 
			procTimer.start(1)
			pass
		Effects.REGEN:
			pass
		Effects.SLOW:
			pass
		Effects.GHOSTING:
			pass
		Effects.INVULNERABILITY:
			pass
	pass # Replace with function body.


func _on_duration_timer_timeout():
	end()
	pass # Replace with function body.


func end(): #undoes the effects and removes itself from the node it's attached to
	icon.queue_free()
	match effect:
		Effects.SPEED:
			#character speed -= value
			pass
		Effects.BLEED:
			pass
		Effects.REGEN:
			pass
		Effects.SLOW:
			pass
		Effects.GHOSTING:
			pass
		Effects.INVULNERABILITY:
			pass
	queue_free()
