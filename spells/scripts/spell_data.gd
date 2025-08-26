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
