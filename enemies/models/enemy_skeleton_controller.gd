extends Node3D
class_name EnemySkeletonController

signal attack_trigger

@onready var enemy = get_parent() as Enemy
@onready var anim: AnimationTree = $AnimationTree


func _ready() -> void:
	enemy.attacked.connect(on_attack)
	attack_trigger.connect(enemy.on_anim_attack_trigger)

func _process(delta: float) -> void:
	anim.set("parameters/MoveBlend/blend_position", enemy.velocity.length()/enemy.speed)


func on_attack():
	anim.set("parameters/Attack/request", AnimationNodeOneShot.OneShotRequest.ONE_SHOT_REQUEST_FIRE)


func emit_attack_trigger():
	attack_trigger.emit()
