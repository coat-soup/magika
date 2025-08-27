extends Enemy

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	super._ready()
	nav_agent.velocity_computed.connect(on_velocity_computed)


func _physics_process(delta: float) -> void:
	if not nav_agent: return
	
	nav_agent.target_position = Global.player.global_position
	
	var dir = (nav_agent.get_next_path_position() - global_position).normalized()
	
	global_rotation.y += global_basis.z.signed_angle_to(dir, Vector3.UP) * turn_speed * delta
	
	var nav_vel : Vector3 = global_basis.z * speed if can_move else Vector3.ZERO
	
	
	nav_agent.set_velocity(nav_vel)
	
	#velocity = nav_vel + get_boost_vel()
	
	if not is_on_floor(): velocity += get_gravity()
	
	if nav_agent.distance_to_target() < attack_range:
		attack()


func on_velocity_computed(safe_vel : Vector3):
	velocity = safe_vel + get_boost_vel()
	if not is_on_floor(): velocity += get_gravity()
	move_and_slide()
