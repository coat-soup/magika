extends Node3D
class_name Explosion

@export var particles_scene : PackedScene
@onready var area: Area3D = $Area3D
@onready var col: CollisionShape3D = $Area3D/CollisionShape3D


func explode(radius, damage):
	var p = particles_scene.instantiate() as Node3D
	get_tree().root.add_child(p)
	p.global_position = global_position
	p.global_scale(Vector3.ONE * radius)
	
	(col.shape as SphereShape3D).radius = radius
	
	
	await get_tree().create_timer(0.1).timeout
	
	print("bodies: ", area.get_overlapping_bodies())
	
	for body in area.get_overlapping_bodies():
		var health : Health = body.get_node_or_null("Health") as Health
		if health:
			health.take_damage(damage)
