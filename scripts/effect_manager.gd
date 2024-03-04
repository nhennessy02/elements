extends Node

var effectTemplate = preload("res://prefabs/effect.tscn")
enum Effects {SPEED,BLEED,REGEN,SLOW,GHOSTING,INVULNERABILITY}
# Called when the node enters the scene tree for the first time.

func attach_effect(nodePath : NodePath, effect : Effect, duration : float):
	var node = get_node(nodePath)
	#if node already has the effect, refresh the timer
	for child in node.get_children():
		if child is Effect:
			if child.effect == effect:
				child.durationTimer.start(duration)
				return
	#if node doesnt have the effect add it to the node
	var effectNode = effectTemplate.instantiate()
	effectNode.duration = duration
	effectNode.effect = effect
	node.add_child(effectNode)
	pass
