extends Node3D

@export var movement : PlayerMovement
@onready var anim: AnimationTree = $AnimationTree
@export var vel_change_speed := 8.0
var rel_vel = Vector3.ZERO


func _process(delta: float) -> void:
	rel_vel = lerp(rel_vel, movement.body.velocity * movement.body.global_basis, vel_change_speed * delta)
	anim.set("parameters/MoveBlend/blend_position", Vector2(rel_vel.x, -rel_vel.z) / movement.speed)
