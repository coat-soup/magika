extends EnemyAttack
class_name EnemyMeleeAttack

@onready var area_3d: Area3D = $Area3D


func activate(enemy: Enemy, _damage : int):
	super.activate(enemy, _damage)
	
	print("melee attack activating")
	
	await get_tree().create_timer(0.05).timeout
	
	for body in area_3d.get_overlapping_bodies():
		print("attack overlaps ", body)
		body = body as PlayerManager
		if body:
			print("Hit player!")
			body.health.take_damage(_damage, 2)
			break
	
	queue_free()
