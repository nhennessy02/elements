extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_pressed():
	GameManager.close_program()
	pass # Replace with function body.


func _on_resume_button_pressed():
	print("resume game")
	GameManager.resume_game()
	pass # Replace with function body.
