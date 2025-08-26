extends Control
class_name UIDraggable

signal drag_started
signal drag_ended

var dragging := false
var hovering := false


func _ready() -> void:
	print("readying draggables")
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_primary") and hovering: begin_drag()
	if event.is_action_released("ui_primary") and dragging: end_drag()


func _process(delta: float) -> void:
	if dragging:
		global_position = get_viewport().get_mouse_position() - size/2


func begin_drag():
	dragging = true
	
	drag_started.emit()


func end_drag():
	dragging = false
	
	drag_ended.emit()


func on_mouse_entered():
	hovering = true

func on_mouse_exited():
	hovering = false
