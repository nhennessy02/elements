extends Node

@onready var durationTimer = $DurationTimer
@onready var procTimer = $ProcTimer
var duration;
var proc;
var value;
var effect;

# Called when the node enters the scene tree for the first time.
func _ready():
	durationTimer.start(duration)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_proc_timer_timeout():
	pass # Replace with function body.


func _on_duration_timer_timeout():
	end()
	pass # Replace with function body.


func end(): #undoes the effects and removes itself from the node it's attached to
	
	queue_free()
