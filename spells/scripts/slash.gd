extends Spell
class_name Slash

var damaged_list : Array[Health]


func activate():
	super.activate()
	global_scale(Vector3(1.0, 1.0, 1.0) * spell_data.get_size())


func _physics_process(delta: float) -> void:
	if not active: return
	
	shape_cast.target_position = velocity * delta
	
	if shape_cast.is_colliding() and not (shape_cast.get_collider(0) as PlayerManager):
		handle_collision()
	
	global_position += velocity * delta
	velocity.y -= (drop_speed / spell_data.get_range()) * delta
	look_at(global_position + velocity, Vector3.UP, true)
	
	distance_covered += velocity.length() * delta
	if distance_covered >= spell_data.get_range(): dissipate()


func handle_collision():
	hit.emit()
	for i in range(shape_cast.get_collision_count()):
		if not is_instance_valid(shape_cast.get_collider(i)): continue
		var health : Health = shape_cast.get_collider(i).get_node_or_null("Health") as Health
		if health and damaged_list.find(health) == -1:
			health.take_damage(spell_data.get_power(), 1)
			damaged_list.append(health)
