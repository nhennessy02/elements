extends Control

@export var level_name : String = "sprint2_build"

# PLAY BUTTON
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/" + level_name + ".tscn")

# QUIT BUTTON
func _on_quit_button_pressed():
	get_tree().quit()
