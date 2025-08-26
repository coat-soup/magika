extends Node3D
class_name Explosion

@export var particles_scene : PackedScene
@onready var area: Area3D = $Area3D
@onready var col: CollisionShape3D = $Area3D/CollisionShape3D


static func explode_at_point(source_node : Node3D, pos : Vector3, radius : float, damage : float, source_id : int = 0, particles : PackedScene = null):
	var exp = preload("res://spells/scenes/explosion.tscn").instantiate() as Explosion
	exp.particles_scene = particles
	source_node.get_tree().root.add_child(exp)
	exp.global_position = pos
	exp.explode(radius, damage, source_id)
	
	await source_node.get_tree().create_timer(3.0).timeout
	exp.queue_free()


func explode(radius, damage, source = 0):
	if particles_scene:
		var p = particles_scene.instantiate() as Node3D
		get_tree().root.add_child(p)
		p.global_position = global_position
		p.global_scale(Vector3.ONE * radius)
	
	(col.shape as SphereShape3D).radius = radius
	
	
	await get_tree().create_timer(0.1).timeout
	
	for body in area.get_overlapping_bodies():
		var health : Health = body.get_node_or_null("Health") as Health
		if health:
			health.take_damage(damage, source)
