extends Node
class_name Powerup

@onready var area: Area3D = $Area3D
enum UpgradeType {POWER, SPEED, RANGE, CAST_RATE, SIZE}
@export var type : UpgradeType

func _ready() -> void:
	area.body_entered.connect(body_entered)


func body_entered(body : Node3D):
	body = body as PlayerManager
	if body:
		Global.ui.play_audio(preload("res://sfx/powerup_collect.wav"))
		body.spell_manager.get_powerup(type)
		queue_free()
