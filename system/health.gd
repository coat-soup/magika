extends Node
class_name Health

signal took_damage
signal died

@export var max_health : int = 100
@onready var cur_health : int = max_health


func take_damage(amount : int):
	cur_health = max(0, cur_health - amount)
	
	print("taking %d damage, health now %d/%d" % [amount, cur_health, max_health])
	
	took_damage.emit()
	
	if cur_health <= 0:
		die()


func die():
	died.emit()
