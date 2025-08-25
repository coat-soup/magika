extends Node3D
class_name PlayerSpellManager

@export var spells : Array[SpellData]
var cooldowns : Array[float]
var cur_spell : int = 0
var camera : Node3D

const SPELL_CIRCLE_FX = preload("res://vfx/scenes/spell_circle_fx.tscn")


func _ready() -> void:
	camera = (get_parent_node_3d() as PlayerManager).camera_pivot
	
	for spell in spells:
		cooldowns.append(0)


func _process(delta: float) -> void:
	if Input.is_action_pressed("attack"): try_cast_spell(cur_spell)
	
	for i in range(len(cooldowns)):
		if cooldowns[i] > 0:
			cooldowns[i] -= delta


func try_cast_spell(i):
	if cooldowns[i] > 0:
		return
	
	var spell = load(spells[i].prefab_path).instantiate() as Spell
	spell.spell_data = spells[i]
	get_tree().root.add_child(spell)
	spell.global_position = global_position
	spell.look_at(spell.global_position + camera.global_basis.z)
	spell.activate()
	
	cooldowns[i] = 1.0 / spells[i].cast_rate
	
	var fx = SPELL_CIRCLE_FX.instantiate()
	get_tree().root.add_child(fx)
	fx.global_position = global_position
	fx.global_rotation = global_rotation
