extends Node
class_name Enemy

@export var health : Health

func _ready() -> void:
	health.died.connect(queue_free)
