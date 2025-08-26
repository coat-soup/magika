extends Control
class_name UIManager

@onready var hit_marker: TextureRect = $Hud/HitMarker
@onready var audio: AudioStreamPlayer = $UIAudio


func flash_hitmarker():
	play_audio(preload("res://sfx/hitmarker.wav"))
	
	hit_marker.visible = true
	await get_tree().create_timer(0.1).timeout
	hit_marker.visible = false


func play_audio(stream : AudioStream):
	audio.stream = stream
	audio.play()
