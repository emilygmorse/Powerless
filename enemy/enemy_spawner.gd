extends Node2D

var spawn_points: Array = []
var first_spawn: bool = true
var chosen_spawn
var previous_spawn

enum ENEMY_KEY {
	ENEMY_SHADOW
}

const ENEMY = { 
ENEMY_KEY.ENEMY_SHADOW: preload("res://enemy/enemy_shadow.tscn")
}

@export var spawn_time: float = 3.0
@export var enemy_type: ENEMY_KEY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in self.get_children():
		spawn_points.insert(0, i)
	get_tree().create_timer(spawn_time).timeout.connect(spawn_enemy)

func spawn_enemy() -> void:
	var spawn_num = randi_range(0, spawn_points.size()-1)
	chosen_spawn = spawn_points[spawn_num]
	var enemy_spawned = ENEMY[enemy_type].instantiate()
	enemy_spawned.global_position = chosen_spawn.global_position
	call_deferred("add_child", enemy_spawned)
	get_tree().create_timer(spawn_time).timeout.connect(spawn_enemy)
	prevent_repeat_spawn()
	
func prevent_repeat_spawn() -> void:
	spawn_points.erase(chosen_spawn)
	if first_spawn == false:
		spawn_points.insert(0, previous_spawn)
	else:
		first_spawn = false
	previous_spawn = chosen_spawn
