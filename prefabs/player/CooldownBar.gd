extends ProgressBar
@onready var timer = $"../Wand".cooldownTimer
var cooldownValue
# Called when the node enters the scene tree for the first time.
func _ready():
	cooldownValue = timer.get_wait_time()
	pass


# Called every frame. 'delta' is the elapsedaw time since the previous frame.
func _process(delta):
	#print(value)
	value = timer.get_time_left()
	pass
	

func _on_inventory_combo_created(spellName, useRate, scene, wandColor):
	cooldownValue = timer.get_wait_time()
	max_value = cooldownValue
	value = cooldownValue
