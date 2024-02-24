extends CanvasLayer


func _on_exit_button_pressed():
	GameManager.close_program()
	pass # Replace with function body.

func _on_resume_button_pressed():
	print("resume game")
	GameManager.resume_game()
	pass # Replace with function body.
