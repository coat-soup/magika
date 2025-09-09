extends Spell
class_name Dash

var dir : Vector3


func agg_speed() -> float:
	return (spell_data.get_speed() + spell_data.get_speed() * (spell_data.get_power() - 1)) # base power should just be 1 always for this spell


func activate():
	super.activate()
	
	Global.player.player_movement.dashing = true
	Global.player.player_movement.turn_speed *= 3
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir == Vector2.ZERO: input_dir = Vector2(0, -1)
	dir = (Global.player.camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	print("dash input: ", input_dir, " | dash global dir: ", dir)
	
	#Global.player.player_movement.body.global_rotation.y = Global.player.camera_pivot.global_rotation.y
	
	await get_tree().create_timer(spell_data.get_range() / (agg_speed() * get_physics_process_delta_time())).timeout
	dissipate()


func _physics_process(delta: float) -> void:
	Global.player.player_movement.body.velocity = dir * agg_speed() * delta
	Global.player.player_movement.body.move_and_slide()


func dissipate():
	Global.player.player_movement.dashing = false
	Global.player.player_movement.turn_speed /= 3
	super.dissipate()
