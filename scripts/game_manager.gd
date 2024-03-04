extends Node


# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#allows you to pause the game and open the menu
	if Input.is_action_just_pressed("menu") and not get_tree().paused:
		pause_game()
			
	elif Input.is_action_just_pressed("menu") and get_tree().paused:
		resume_game()
	

func resume_game():
	get_tree().paused = false
	PauseMenu.visible = false

func pause_game():
	get_tree().paused = true
	PauseMenu.visible = true
	
# this function sends a notification out to all nodes that the program is closing
func close_program():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	
#this function closes the program
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
