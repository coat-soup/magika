extends Resource
class_name SpellData

@export var spell_name : String
@export var prefab_path : String

@export var power : float = 1.0
@export var speed : float = 1.0
@export var range : float = 1.0
@export var cast_rate : float = 1.0
@export var size : float = 1.0

@export var icon : Texture2D


var pow_ups : int = 0
var speed_ups : int = 0
var range_ups : int = 0
var cast_ups : int = 0
var size_ups : int = 0


@export var pow_upscale : float = 0.2
@export var speed_upscale : float = 0.2
@export var range_upscale : float = 0.2
@export var cast_upscale : float = 0.2
@export var size_upscale : float = 0.2


func get_power() -> float:
	return power + power * pow_ups * pow_upscale

func get_speed() -> float:
	return speed + speed * speed_ups * speed_upscale

func get_range() -> float:
	return range + range * range_ups * range_upscale

func get_cast_rate() -> float:
	return cast_rate + cast_rate * cast_ups * cast_upscale

func get_size() -> float:
	return size + size * size_ups * size_upscale
