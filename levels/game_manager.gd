extends Node3D

@export var player : PlayerManager
@export var camera : Camera3D
@export var ui : UIManager


func _ready() -> void:
	Global.player = player
	Global.camera = camera
	Global.ui = ui


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE): get_tree().quit()
