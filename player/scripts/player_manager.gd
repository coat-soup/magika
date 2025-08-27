extends CharacterBody3D
class_name PlayerManager

@export var camera_pivot : Node3D
@onready var player_movement: PlayerMovement = $PlayerMovement
@onready var spell_manager: PlayerSpellManager = $PlayerSpellManager
@onready var health: Health = $Health
