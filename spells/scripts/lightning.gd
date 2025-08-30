extends Spell
class_name Lightning

@export var summon_delay : float = 3.0


func activate():
	var space_state = get_world_3d().direct_space_state
	var end_pos = global_position + global_basis.z.normalized() * spell_data.get_range()
	
	var query = PhysicsRayQueryParameters3D.create(global_position, end_pos, 0b1)
	var result = space_state.intersect_ray(query)
	
	if result: do_thing_at(result.position)
	else:
		var end_down = end_pos - Vector3.UP * 10.0
		query = PhysicsRayQueryParameters3D.create(end_pos, end_down, 0b1)
		result = space_state.intersect_ray(query)
		if result: do_thing_at(result.position)


func do_thing_at(pos : Vector3):
	global_position = pos
	
	global_rotation = Vector3.ZERO
	
	global_scale(Vector3.ONE * spell_data.get_size())
	$AnimationPlayer.speed_scale = spell_data.get_speed() / summon_delay
	$AnimationPlayer.play("cast")
	
	$SpellCircle.global_position = pos + Vector3(0, 8.0, 0)
	$SpellCircle.look_at(pos + Vector3.UP * 50.0)
	
	await get_tree().create_timer(summon_delay / spell_data.get_speed()).timeout
	
	$LightningSFX.pitch_scale = randf_range(0.8, 1.2)
	$LightningSFX.play()
	for body in $Area3D.get_overlapping_bodies():
		print("zapping ", body)
		if body as PlayerManager:
			body.health.take_damage(spell_data.get_power(), 1)
		elif body as Enemy:
			body.health.take_damage(spell_data.get_power(), 1)
			body.stun(3.0)
	#Explosion.explode_at_point(self, pos, spell_data.get_size(), spell_data.get_power(), 1)
