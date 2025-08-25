extends AudioStreamPlayer3D

@export var limits : Vector2 = Vector2(0.8, 1.2)

func _enter_tree() -> void:
	pitch_scale = randf_range(limits.x, limits.y)
