extends Node3D
class_name Spell

signal cast
signal dissipated
signal hit

var spell_data : SpellData
@onready var shape_cast: ShapeCast3D = $ShapeCast3D

var velocity : Vector3
var distance_covered : float


func activate() -> void:
	velocity = global_basis.z.normalized() * spell_data.speed
	
	cast.emit()


func _physics_process(delta: float) -> void:
	shape_cast.target_position = velocity * delta
	
	if shape_cast.is_colliding():
		handle_collision()
	
	global_position += velocity * delta
	
	distance_covered += velocity.length() * delta
	if distance_covered >= spell_data.range: dissipate()


func handle_collision():
	hit.emit()
	queue_free()


func dissipate():
	dissipated.emit()
	queue_free()
