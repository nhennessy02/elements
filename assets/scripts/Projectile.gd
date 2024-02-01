extends Node2D

var direction

@export var speed : float = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.from_angle(global_rotation) * speed * delta; #Phillip - from_angle gives a unit vector in the direction from the angle given

func _on_area_2d_body_entered(body):
	pass # Replace with function body.
