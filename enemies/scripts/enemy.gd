extends CharacterBody3D
class_name Enemy

signal attacked

@export var health : Health
@export_range(0.0, 1.0) var powerup_chance = 0.5

@export var damage : int = 20
@export var speed : float = 5.0
@export var turn_speed : float = 5.0
@export var attack_range : float = 1.5

@export var attack_move_delay : float = 1.5
var can_move := true

@export var attack_prefab : PackedScene
@export var attack_interval : float = 3.0
var can_attack := true

var boost_vel : Vector3
var boost_duration : float = 1.0
var boost_timer : float = 0.0


func _ready() -> void:
	health.died.connect(on_died)


func _process(delta: float) -> void:
	if boost_timer > 0: boost_timer -= delta


func boost(vel : Vector3, duration : float):
	boost_vel = vel
	boost_duration = duration
	boost_timer = duration


func get_boost_vel():
	if boost_timer <= 0: return Vector3.ZERO
	else: return boost_vel * pow(boost_timer/boost_duration, 0.5)


func on_died():
	if randf() < powerup_chance:
		var powerup = preload("res://spells/scenes/powerup.tscn").instantiate()
		get_tree().root.add_child(powerup)
		powerup.global_position = global_position
		powerup.type = randi_range(0, Powerup.UpgradeType.size() - 1)
	queue_free()


func attack():
	if not can_attack: return
	
	attacked.emit()
	
	can_attack = false
	can_move = false
	
	if attack_move_delay < attack_interval:
		await get_tree().create_timer(attack_move_delay).timeout
		can_move = true
		await get_tree().create_timer(attack_interval - attack_move_delay).timeout
		can_attack = true
	else:
		await get_tree().create_timer(attack_interval).timeout
		can_attack = true
		await get_tree().create_timer(attack_move_delay - attack_interval).timeout
		can_move = true


func on_anim_attack_trigger():
	var attack = attack_prefab.instantiate() as EnemyAttack
	get_tree().root.add_child(attack)
	attack.global_position = $AttackPoint.global_position
	attack.global_rotation = global_rotation
	
	attack.activate(self, damage)
