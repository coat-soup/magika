extends Control
class_name UIManager

@onready var hit_marker: TextureRect = $Hud/HitMarker
@onready var audio: AudioStreamPlayer = $UIAudio

@export var spell_slots : Array[Control]
var powerups : Array[PowerupWidget]
var active_slot := -1


@export var spell_icons : Array[UIDraggable]
var spellbook_active := false



func _ready() -> void:
	toggle_spellbook(false)
	
	await get_tree().process_frame
	for i in range(len(Global.player.spell_manager.spells)):
		equip_spell(Global.player.spell_manager.spells[i], i)
	
	for i in range(len(spell_slots)):
		spell_slots[i].mouse_entered.connect(set_active_slot.bind(i))
		spell_slots[i].mouse_exited.connect(set_active_slot.bind(-1))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spellbook"): toggle_spellbook(!spellbook_active)


func flash_hitmarker():
	play_audio(preload("res://sfx/hitmarker.wav"))
	
	hit_marker.visible = true
	await get_tree().create_timer(0.1).timeout
	hit_marker.visible = false


func play_audio(stream : AudioStream):
	audio.stream = stream
	audio.play()


func set_active_slot(slot : int):
	active_slot = slot


func equip_spell(spell : SpellData, slot : int):
	if not is_instance_valid(spell): return
	(spell_slots[slot].get_child(1) as TextureRect).texture = spell.icon


func toggle_spellbook(value):
	spellbook_active = value
	$SpellBook.visible = value
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if value else Input.MOUSE_MODE_CAPTURED


func add_powerup(type : int):
	var p = preload("res://ui/scenes/powerup_widget.tscn").instantiate()
	$SpellBook/PowerupHolder.add_child(p)
	p.position = Vector2(randf(), randf()) * $SpellBook.size
	p.powerup_type = type
	(p.get_node("Label") as Label).text = ["POWER", "SPEED", "RANGE", "CAST", "SIZE"][type]
	
	p.drag_started.connect(powerup_drag_started.bind(p))
	p.drag_ended.connect(powerup_drag_ended.bind(p))



func powerup_drag_started(powerup : PowerupWidget):
	if powerup.connect_spell_slot != -1:
		Global.player.spell_manager.change_powerup(powerup.connect_spell_slot, powerup.powerup_type, -1)
		powerup.connect_spell_slot = -1


func powerup_drag_ended(powerup : PowerupWidget):
	if active_slot != -1 and Global.player.spell_manager.spells[active_slot]:
		powerup.connect_spell_slot = active_slot
		Global.player.spell_manager.change_powerup(powerup.connect_spell_slot, powerup.powerup_type, -1)
