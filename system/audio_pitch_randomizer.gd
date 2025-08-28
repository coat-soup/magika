extends AudioStreamPlayer3D

@export var limits : Vector2 = Vector2(0.8, 1.2)

func _enter_tree():
	randomize_pitch()


func randomize_and_play():
	randomize_pitch()
	play()


func randomize_pitch():
	pitch_scale = randf_range(limits.x, limits.y)
