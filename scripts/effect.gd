extends Node

# Effect should probably be consistent by name for example speed always increases character speed by a fixed amount
# Speed increases the character speed by 100
# Bleed hurts for 1 damage a second for 10 seconds
enum Effect {SPEED,BLEED}

@onready var durationTimer = $DurationTimer
@onready var procTimer = $ProcTimer
var duration;
var effect;

# Called when the node enters the scene tree for the first time.
func _ready():
	durationTimer.start(duration)
	match effect:
		Effect.SPEED:
			#character speed += value
			pass
		Effect.BLEED:
			get_node("./Damageable").hit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_proc_timer_timeout():
	match effect:
		Effect.BLEED:
			get_node("./Damageable").hit(1)
	pass # Replace with function body.


func _on_duration_timer_timeout():
	end()
	pass # Replace with function body.


func end(): #undoes the effects and removes itself from the node it's attached to
	match effect:
		Effect.SPEED:
			#character speed -= value
			pass
	queue_free()
