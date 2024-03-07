extends Sprite2D

var delete : bool = false
@export var type : String = "item"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if delete:
		queue_free()
