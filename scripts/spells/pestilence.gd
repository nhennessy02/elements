extends Node2D

var damagePerTick = 1
var enemyList = []

func _ready():
	self.rotation = 0
	
func _on_damage_rate_timeout():
	for enemy in enemyList:
		for node in enemy.get_children():
			if node is Damageable:
				node.hit(damagePerTick)


func _on_life_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	print("body entered")
	enemyList.append(body)


func _on_area_2d_body_exited(body):
	print("body entered")
	enemyList.erase(body)
