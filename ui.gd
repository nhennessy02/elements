extends CanvasLayer
class_name UI

#ui properties
@onready var health_label = $Control/MarginContainer/Label

func update_health_label(value):
	health_label.text = "Health: " + value
