extends Node
#follows this video by DashNothing "Damage Numbers in Godot 4 | Let's Godot" 
#link https://www.youtube.com/watch?v=F0DQLSiLkjg

func display_number(value: int, position: Vector2, color = Color8(255,255,255)):
	#creating the number
	var number = Label.new()
	number.global_position = position
	number.text = str(abs(value)) # shouldn't probably use abs
	number.z_index = 5 # should be above everything
	number.label_settings = LabelSettings.new()

	number.label_settings.font_color = color
	number.label_settings.font_size = 36
	number.label_settings.outline_color = Color8(0,0,0)
	number.label_settings.outline_size = 1
	
	call_deferred("add_child",number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	#animating the number
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
