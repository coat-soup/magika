extends EnemyAttack
class_name EnemyProjectileAttack

@export var speed : float = 20.0
@export var duration : = 3.0
@onready var area_3d: Area3D = $Area3D


func activate(enemy : Enemy, _damage : int):
	super.activate(enemy, _damage)
	print("setting damage to ", damage, " ", _damage)
	
	area_3d.body_entered.connect(on_body_entered)
	
	look_at(Global.player.global_position + Vector3(0,1.0,0), Vector3.UP, true)
	
	await get_tree().create_timer(duration).timeout
	queue_free()


func _process(delta: float) -> void:
	if active: global_position += global_basis.z * speed * delta


func on_body_entered(body : Node3D):
	body = body as PlayerManager
	if body:
		body.health.take_damage(damage, 2)
		queue_free()
