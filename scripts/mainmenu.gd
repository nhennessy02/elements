extends Control

# PLAY BUTTON
func _on_play_button_pressed():
	get_tree().change_scene_to_file.call_deferred("res://scenes/game.tscn")

# QUIT BUTTON
func _on_quit_button_pressed():
	get_tree().quit()
