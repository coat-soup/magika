extends Node
class_name Health

signal took_damage
signal died

@export var max_health : int = 100
@onready var cur_health : int = max_health


func take_damage(amount : int, source : int): #source: 0 is system, 1 is player, 2 is enemy
	cur_health = max(0, cur_health - amount)
	
	print("%s took %ddmg -> %d/%dhp" % [get_parent().name, amount, cur_health, max_health])
	
	if source == 1 and get_parent() != Global.player: Global.ui.flash_hitmarker()
	
	took_damage.emit()
	
	if cur_health <= 0:
		die()


func die():
	died.emit()
