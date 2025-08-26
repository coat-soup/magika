extends CharacterBody3D
class_name Enemy

@export var health : Health
@export_range(0.0, 1.0) var powerup_chance = 0.5


func _ready() -> void:
	health.died.connect(on_died)


func on_died():
	if randf() < powerup_chance:
		var powerup = preload("res://spells/scenes/powerup.tscn").instantiate()
		get_tree().root.add_child(powerup)
		powerup.global_position = global_position
	queue_free()
