extends Enemy

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var nav_dir : Vector3
var nav_update_tick_interval : int = 10
var nav_update_ticks_remaining : int = 0


func _ready() -> void:
	super._ready()
	nav_agent.velocity_computed.connect(on_velocity_computed)
	nav_update_ticks_remaining = randi() % nav_update_tick_interval


func _physics_process(delta: float) -> void:
	if not nav_agent: return
	
	nav_agent.target_position = Global.player.global_position
	
	if nav_update_ticks_remaining > 0: nav_update_ticks_remaining -= 1
	else:
		nav_update_ticks_remaining = nav_update_tick_interval
		nav_dir = (nav_agent.get_next_path_position() - global_position).normalized()
	
	
	global_rotation.y += global_basis.z.signed_angle_to(nav_dir, Vector3.UP) * turn_speed * delta
	
	var nav_vel : Vector3 = Vector3(global_basis.z.x, nav_dir.y, global_basis.z.z) * speed if can_move else Vector3.ZERO
	
	nav_agent.set_velocity(nav_vel)
	
	global_position += velocity * delta
	
	if nav_agent.distance_to_target() < attack_range:
		attack()


func on_velocity_computed(safe_vel : Vector3):
	if nav_update_ticks_remaining <= 1:
		velocity = safe_vel + get_boost_vel()
		#if not is_on_floor(): velocity += get_gravity()
		#move_and_slide()
