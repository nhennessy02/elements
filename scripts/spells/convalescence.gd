extends Node

@onready var timer = $ActivationTimer
var player
var healAmount = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	self.rotation = 0;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = player.position
	if timer.time_left > 0 and Input.is_action_just_released("fire_wand"):
		fizzle()
		pass

func fizzle():
	timer.stop()
	queue_free()
	pass
	
func activate():
	player.get_child(3).hit(-healAmount) #child 3 is the health tracker of the player, hitting for negative heals
	pass

func _on_activation_timer_timeout():
	activate()
	queue_free()
	pass # Replace with function body.
