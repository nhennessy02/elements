extends Node

var effectTemplate = preload("res://prefabs/effect.tscn")
# Called when the node enters the scene tree for the first time.

func attach_effect(node, effect : int, duration : float):
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
	effectNode.attachedNode = node;
	node.add_child(effectNode)
	pass
