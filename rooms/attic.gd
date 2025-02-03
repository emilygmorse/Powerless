extends ROOM

@onready var enemy_spawner: Node2D = $EnemySpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_light_status(GameManager.puzzle_3_solved)
	SignalManager.puzzle_solved.connect(puzzle_solved)
	if GameManager.puzzle_3_solved == false:
		enemy_spawner.spawn_enemy()

func puzzle_solved() -> void:
	enemy_spawner.queue_free()
	GameManager.puzzle_3_solved = true
	SignalManager.destroy_enemies.emit()
	room_light_status(GameManager.puzzle_3_solved)
	DialogueManager.show_dialogue_balloon(load("res://dialogue/puzzle_attic_done.dialogue"), "start")


func _on_breaker_3_puzzle_start() -> void:
	SignalManager.puzzle_mode.emit()
