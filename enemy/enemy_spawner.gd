extends Node2D

@export var spawn_time: float = 3.0
@export var skelly_spawn: bool = false
@export var tongue_spawn: bool = false
@export var mouth_spawn: bool = false
@export var spider_spawn: bool = false
@export var crawler_spawn: bool = false
@export var snake_spawn: bool = false



var spawn_points: Array = []
var spawn_time_diff: float = spawn_time/10
var first_spawn: bool = true
var enemy_type: int
var chosen_spawn
var previous_spawn

var all_enemy_scenes: Dictionary = { 
ENEMY_SKELLY = preload("res://enemy/enemy_skelly.tscn"),
ENEMY_TONGUE = preload("res://enemy/enemy_tongue.tscn"),
ENEMY_MOUTH = preload("res://enemy/enemy_mouth.tscn"),
ENEMY_SPIDER = preload("res://enemy/enemy_spider.tscn"),
ENEMY_CRAWLER = preload("res://enemy/enemy_crawler.tscn"),
ENEMY_SNAKE = preload("res://enemy/enemy_snake.tscn")
}

var new_enemy_list: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_spawn_list()
	for i in self.get_children():
		spawn_points.insert(0, i)
	SignalManager.activate_enemy_spawner.connect(spawn_enemy)
	#get_tree().create_timer(spawn_time).timeout.connect(spawn_enemy)

func enemy_spawn_list() -> void:
	var array_count: int = -1
	if snake_spawn == true:
		array_count += 1
		new_enemy_list.get_or_add(array_count, all_enemy_scenes.ENEMY_SNAKE)
	if skelly_spawn == true:
		array_count += 1
		new_enemy_list.get_or_add(array_count, all_enemy_scenes.ENEMY_SKELLY)
	if tongue_spawn == true:
		array_count += 1
		new_enemy_list.get_or_add(array_count, all_enemy_scenes.ENEMY_TONGUE)
	if mouth_spawn == true:
		array_count += 1
		new_enemy_list.get_or_add(array_count, all_enemy_scenes.ENEMY_MOUTH)
	if spider_spawn == true:
		array_count += 1
		new_enemy_list.get_or_add(array_count, all_enemy_scenes.ENEMY_SPIDER)
	if crawler_spawn == true:
		array_count += 1
		new_enemy_list.get_or_add(array_count, all_enemy_scenes.ENEMY_CRAWLER)
	if array_count == -1:
		print("No enemies selected to spawn!")

func spawn_enemy() -> void:
	var spawn_num = randi_range(0, spawn_points.size()-1)
	chosen_spawn = spawn_points[spawn_num]
	enemy_type = randi_range(0, new_enemy_list.size()-1)
	var enemy_spawned = new_enemy_list[enemy_type].instantiate()
	enemy_spawned.global_position = chosen_spawn.global_position
	call_deferred("add_child", enemy_spawned)
	get_tree().create_timer(randf_range(spawn_time-spawn_time_diff, spawn_time+spawn_time_diff)).timeout.connect(spawn_enemy)
	prevent_repeat_spawn()
	
func prevent_repeat_spawn() -> void:
	spawn_points.erase(chosen_spawn)
	if first_spawn == false:
		spawn_points.insert(0, previous_spawn)
	else:
		first_spawn = false
	previous_spawn = chosen_spawn
