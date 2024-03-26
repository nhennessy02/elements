extends TextureProgressBar
@onready var timer = $"../Wand".cooldownTimer
var cooldownValue
# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = 0.2
	value = max_value;
	pass


# Called every frame. 'delta' is the elapsedaw time since the previous frame.
func _process(delta):
	value = timer.get_time_left()
	
	if (max_value < 0.5):
		visible = false
	else:
		visible = true
	
	if(value <= 0):
		value = max_value
	

func _on_inventory_combo_created(spellName, useRate, scene, wandColor):
	max_value = useRate;
	value = useRate;
