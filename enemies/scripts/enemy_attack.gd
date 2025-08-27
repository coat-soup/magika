extends Node3D
class_name EnemyAttack

var damage : int
var enemy : Enemy

var active := false


func activate(_enemy : Enemy, _damage : int):
	damage = _damage
	enemy = _enemy
	
	active = true
