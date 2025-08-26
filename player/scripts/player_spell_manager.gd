extends Node3D
class_name PlayerSpellManager

@export var spells : Array[SpellData]
var cooldowns : Array[float]
var cur_spell : int = 0
var camera : Node3D

const SPELL_CIRCLE_FX = preload("res://vfx/scenes/spell_circle_fx.tscn")


func _ready() -> void:
	camera = (get_parent_node_3d() as PlayerManager).camera_pivot.get_child(0)
	
	for spell in spells:
		cooldowns.append(0)


func _input(event: InputEvent) -> void:
	var scroll_dir = int(Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN)) - int(Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP))
	if scroll_dir != 0:
		cur_spell = posmod((cur_spell + scroll_dir), len(spells))
		while not spells[cur_spell]: cur_spell = posmod((cur_spell + scroll_dir), len(spells))


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
	
	var end_pos = get_camera_ray_pos(spells[i].range)
	
	spell.look_at(end_pos, Vector3.UP, true)
	
	var fx = SPELL_CIRCLE_FX.instantiate()
	get_tree().root.add_child(fx)
	fx.global_position = global_position
	fx.global_rotation = spell.global_rotation
	
	spell.activate()
	cooldowns[i] = 1.0 / spells[i].cast_rate



func get_camera_ray_pos(dist) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var end_pos = camera.global_position + -camera.global_basis.z.normalized() * dist * 1.5
	var query = PhysicsRayQueryParameters3D.create(camera.global_position, end_pos, 0b1)
	var result = space_state.intersect_ray(query)
	return result.position if result else end_pos


func change_powerup(spell_slot : int, type : int, diff : int): # diff is -1 or 1 (1 adds, -1 subtracts)
	match type:
		Powerup.UpgradeType.POWER:
			spells[spell_slot].pow_ups += diff
		Powerup.UpgradeType.SPEED:
			spells[spell_slot].speed_ups += diff
		Powerup.UpgradeType.RANGE:
			spells[spell_slot].range_ups += diff
		Powerup.UpgradeType.CAST_RATE:
			spells[spell_slot].cast_ups += diff
		Powerup.UpgradeType.SIZE:
			spells[spell_slot].size_ups += diff
