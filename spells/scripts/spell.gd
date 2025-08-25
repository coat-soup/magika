extends Node3D
class_name Spell

signal cast
signal dissipated
signal hit

var spell_data : SpellData
@onready var shape_cast: ShapeCast3D = $ShapeCast3D
@export var impact_particles : PackedScene

var velocity : Vector3
var distance_covered : float


func activate() -> void:
	velocity = global_basis.z.normalized() * spell_data.speed
	
	cast.emit()


func _physics_process(delta: float) -> void:
	shape_cast.target_position = velocity * delta
	
	if shape_cast.is_colliding():
		handle_collision()
	
	global_position += velocity * delta
	
	distance_covered += velocity.length() * delta
	if distance_covered >= spell_data.range: dissipate()


func handle_collision():
	hit.emit()
	if spell_data.size == 0:
		var health : Health = shape_cast.get_collider(0).get_node_or_null("Health") as Health
		if health:
			print("hit health thing. sending damage")
			health.take_damage(spell_data.power)
	else:
		var exp = preload("res://spells/scenes/explosion.tscn").instantiate() as Explosion
		exp.particles_scene = impact_particles
		get_tree().root.add_child(exp)
		exp.global_position = shape_cast.get_collision_point(0)
		exp.explode(spell_data.size, spell_data.power)
		
	
	queue_free()


func dissipate():
	dissipated.emit()
	queue_free()
