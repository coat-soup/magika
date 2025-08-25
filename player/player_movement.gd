extends Node
class_name PlayerMovement


@export var speed : float = 7.0
@export var jump_velocity = 6.0
@export var turn_speed = 5.0
@export var sensetivity = 0.005

@export var body : CharacterBody3D
@onready var player: PlayerManager = $".."

var camera_pivot: Node3D
@onready var camera_rt: RemoteTransform3D = $"../RemoteTransform3D"

@export var camera_angle_clamp := Vector2(-80, 30)

var face_camera_timer := 0.0
@export var face_camera_time := 5.0

var landing : bool
signal jump_start
signal jump_land


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_pivot = player.camera_pivot
	camera_rt.remote_path = camera_pivot.get_path()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotate_y(-event.relative.x * sensetivity)
		camera_pivot.rotation.x += (-event.relative.y * sensetivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(camera_angle_clamp.x), deg_to_rad(camera_angle_clamp.y))
		camera_pivot.rotation.z = 0


func _physics_process(delta: float) -> void:
	if face_camera_timer > 0: face_camera_timer -= delta
	
	if Input.is_action_pressed("attack"): face_camera()
	
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if input_dir != Vector2.ZERO or face_camera_timer > 0:
		var target_angle : float = Basis().looking_at(direction, Vector3.UP).get_euler().y if face_camera_timer <= 0 else camera_pivot.global_rotation.y
		body.global_rotation.y = lerp_angle(body.global_rotation.y, target_angle, delta * turn_speed)
	
	direction.y = 0
	direction = direction.normalized()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and body.is_on_floor():
		jump_start.emit()
		body.velocity.y = jump_velocity
		
	
	if body.is_on_floor():
		if direction:
			body.velocity.x = direction.x * speed
			body.velocity.z = direction.z * speed
		else:
			body.velocity.x = lerp(body.velocity.x, direction.x * speed, delta * 10)
			body.velocity.z = lerp(body.velocity.z, direction.z * speed, delta * 10)
		
		if landing:
			landing = false
			if body.velocity.y < 1:
				jump_land.emit()
	else:
		body.velocity.x = lerp(body.velocity.x, direction.x * speed, delta * 2)
		body.velocity.z = lerp(body.velocity.z, direction.z * speed, delta * 2)
		
		if !landing:
			landing = true
	
	body.move_and_slide()


func face_camera():
	face_camera_timer = face_camera_time
