extends Node2D

var damagePerTick = 0.5
var enemyList = []


func _on_damage_rate_timeout():
	for enemy in enemyList:
		if enemy is Damageable:
			enemy.hit(damagePerTick)


func _on_life_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	enemyList.append(body)


func _on_area_2d_body_exited(body):
	enemyList.erase(body)
