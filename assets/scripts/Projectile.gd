extends Node2D

var direction
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2.from_angle(global_rotation) * speed * delta; #Phillip - from_angle gives a unit vector in the direction from the angle given
	pass


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
