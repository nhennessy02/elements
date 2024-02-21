extends Node


# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		close_program()

# this function sends a notification out to all nodes that the program is closing
func close_program():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
#this function closes the program
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
