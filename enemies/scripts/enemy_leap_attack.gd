extends EnemyAttack
class_name EnemyLeapAttack

@onready var area_3d: Area3D = $Area3D
@export var duration := 0.5
@export var leap_strength := 10.0


func activate(_enemy: Enemy, _damage : int):
	super.activate(_enemy, _damage)
	
	area_3d.body_entered.connect(on_body_entered)
	
	reparent(enemy)
	enemy.boost(enemy.global_basis.z * leap_strength, duration)
	
	await get_tree().create_timer(duration).timeout
	
	queue_free()


func on_body_entered(body : Node3D):
	body = body as PlayerManager
	if body:
		body.health.take_damage(damage, 2)
