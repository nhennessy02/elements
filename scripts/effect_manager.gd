extends Node

enum Effect {SPEED,BLEED}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attach_effect(node : NodePath, effect : Effect, duration : float, value : float):
	pass