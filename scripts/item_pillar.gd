extends CharacterBody2D

class_name Pillar

var consumed: bool = false

@onready var anim_sprite = $Interact
@onready var anim_player = $Interact/AnimationPlayer

func _process(_delta):
	if consumed:
		get_parent().delete_all_items()

func _on_area_2d_body_entered(_body):
	anim_sprite.visible = true
	if anim_player != null:
		anim_player.play("active")

func _on_area_2d_body_exited(_body):
	anim_sprite.visible = false
	if anim_player != null:
		anim_player.stop()
