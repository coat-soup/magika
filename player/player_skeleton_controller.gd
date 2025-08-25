extends Node3D

@export var movement : PlayerMovement
@onready var anim: AnimationTree = $AnimationTree
@export var vel_change_speed := 8.0
var rel_vel = Vector3.ZERO

@export var ik_target : Node3D
@onready var upper_arm_ik: LookAtModifier3D = $Armature/Skeleton3D/UpperArmIK
@onready var lower_arm_ik: LookAtModifier3D = $Armature/Skeleton3D/LowerArmIK
@onready var hand_ik: LookAtModifier3D = $Armature/Skeleton3D/HandIK

var ik_influence := 0.0


func _process(delta: float) -> void:
	rel_vel = lerp(rel_vel, movement.body.velocity * movement.body.global_basis, vel_change_speed * delta)
	anim.set("parameters/MoveBlend/blend_position", Vector2(rel_vel.x, -rel_vel.z) / movement.speed)
	
	var do_ik = movement.face_camera_timer > 0
	
	ik_influence = lerp(ik_influence, 1.0 if do_ik else 0.0, delta * (6.0 if do_ik else 3.0))
	upper_arm_ik.influence = ik_influence
	lower_arm_ik.influence = ik_influence
	hand_ik.influence = ik_influence
