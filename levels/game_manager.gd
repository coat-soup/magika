extends Node3D

@export var player : PlayerManager
@export var camera : Camera3D
@export var ui : UIManager

@export var enemy_spawn_data : Array[EnemySpawnData]
@export var enemy_spawn_points : Array[Node3D]
@export var min_spawn_distance_from_player := 50.0

@export var enemy_spawn_interval = 3.0
var max_enemies : float = 10.0
var max_enemy_growth_rate := 30.0 # per minute
var num_enemies : int = 0


func _ready() -> void:
	Global.player = player
	Global.camera = camera
	Global.ui = ui
	
	player.health.died.connect(on_player_died)
	
	for i in range(max_enemies):
		spawn_enemy()
	
	spawn_enemy_loop()


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE): get_tree().quit()


func spawn_enemy_loop():
	while num_enemies < max_enemies:
		spawn_enemy()
	
	max_enemies += max_enemy_growth_rate * enemy_spawn_interval / 60.0
	
	await get_tree().create_timer(enemy_spawn_interval).timeout
	spawn_enemy_loop()


func spawn_enemy():
	var valid_point : bool = false
	var spawn_point : Node3D
	while not valid_point:
		spawn_point = enemy_spawn_points.pick_random()
		valid_point = spawn_point.global_position.distance_to(Global.player.position) >= min_spawn_distance_from_player
	
	var enemy = load(choose_random_enemy(enemy_spawn_data)).instantiate() as Enemy
	add_child(enemy)
	enemy.global_position = spawn_point.position
	
	enemy.health.died.connect(on_enemy_died)
	
	num_enemies += 1


func on_enemy_died():
	num_enemies -= 1


static func choose_random_enemy(spawn_data : Array[EnemySpawnData]) -> String:
	var weight : float = 0
	for d in spawn_data:
		weight += d.spawn_weight
	
	weight = randf_range(0, weight)
	
	for d in spawn_data:
		weight -= d.spawn_weight
		if weight <= 0:
			return d.scene_path
	
	return ""


func on_player_died():
	Global.ui.show_death_screen()
	await get_tree().create_timer(5.0).timeout
	get_tree().reload_current_scene()
