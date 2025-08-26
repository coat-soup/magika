extends Control
class_name PowerupWidget

signal drag_started
signal drag_ended

var dragging := false
var hovering := false
@onready var line_2d: Line2D = $Line2D

var connect_spell_slot : int = -1
var powerup_type : int

@export var line_dist : float = 110.0
@export var pull_strength : float = 1.0
@export var pull_ramp : float = 0.2

var repulsors : Array[Node2D]


func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
	$Repulsor.area_entered.connect(body_entered)
	$Repulsor.area_exited.connect(body_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_primary") and hovering: begin_drag()
	if event.is_action_released("ui_primary") and dragging: end_drag()


func _process(delta: float) -> void:
	if dragging:
		line_2d.points[1] = get_viewport().get_mouse_position() - global_position - line_2d.position
	
	if connect_spell_slot != -1:
		var d = Global.ui.spell_slots[connect_spell_slot].global_position + Global.ui.spell_slots[connect_spell_slot].size/2 - global_position
		var strength = pull_strength * pow(max(0, d.length() - line_dist), pull_ramp)
		global_position += d * strength * delta
		line_2d.points[1] = d - line_2d.position
	
	var repulse_vel = Vector2.ZERO
	for rep in repulsors:
		var d = global_position - rep.global_position
		var strength = (pow(d.length() / $Repulsor/Col.shape.radius, 2)) * 0.2
		print(strength)
		repulse_vel += d * strength
	
	global_position += repulse_vel * delta


func begin_drag():
	dragging = true
	
	print("dragging")
	
	drag_started.emit()


func end_drag():
	dragging = false
	
	line_2d.points[1] = Vector2.ZERO
	
	drag_ended.emit()


func on_mouse_entered():
	hovering = true

func on_mouse_exited():
	hovering = false


func body_entered(body : Node2D):
	if body.is_in_group("ui_repulsor"): repulsors.append(body)


func body_exited(body : Node2D):
	var id = repulsors.find(body)
	if id != -1: repulsors.remove_at(id)
