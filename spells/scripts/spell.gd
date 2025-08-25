extends Node3D
class_name Spell

signal cast
signal dissipated
signal hit

var spell_data : SpellData
@export var shape_cast: ShapeCast3D
@export var impact_particles : PackedScene

var velocity : Vector3
var distance_covered : float

var active := false

func activate():
	velocity = global_basis.z.normalized() * spell_data.speed
	
	cast.emit()
	
	active = true


func _physics_process(delta: float) -> void:
	if not active: return
	
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
		Explosion.explode_at_point(self, shape_cast.get_collision_point(0), spell_data.size, spell_data.power, impact_particles)
	
	queue_free()


func dissipate():
	dissipated.emit()
	queue_free()
