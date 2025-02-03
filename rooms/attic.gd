extends ROOM

@onready var enemy_spawner_2: Node2D = $EnemySpawner2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_light_status(GameManager.puzzle_3_solved)
	SignalManager.puzzle_3_solved.connect(puzzle_solved)
	if GameManager.puzzle_3_solved == false:
		enemy_spawner_2.spawn_enemy()
	if GameManager.attic_intro == false:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_attic.dialogue"), "start")

func puzzle_solved() -> void:
	enemy_spawner.queue_free()
	win_jangle.play()
	GameManager.puzzle_3_solved = true
	$Breaker3.set_monitorable(false)
	SignalManager.destroy_enemies.emit()
	room_light_status(GameManager.puzzle_3_solved)
	create_dialogue_balloon()
	get_tree().create_timer(0.1).timeout.connect(final_dialogue)

func final_dialogue():
	DialogueManager.show_dialogue_balloon(load("res://dialogue/attic_puzzle_done.dialogue"), "start")

func _on_breaker_3_puzzle_start() -> void:
	SignalManager.puzzle_mode.emit()
