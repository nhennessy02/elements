extends CharacterBody2D

class_name Pillar

var consumed: bool = false

func _process(_delta):
	if consumed:
		get_parent().delete_all_items()
