extends ROOM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.outside.emit(true) # for sound purposes
	room_light_status(false)
	SignalManager.puzzle_solved.connect(puzzle_solved)
	$EnemySpawner.spawn_enemy()
	if GameManager.puzzle_2_solved or not GameManager.puzzle_1_solved:
		$Breaker2.set_monitorable(false)
	if GameManager.backyard_intro == false:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_backyard.dialogue"), "start")

func puzzle_solved() -> void:
	GameManager.puzzle_2_solved = true
	$Breaker2.set_monitorable(false)
	$PuzzleSuccess.play()
	DialogueManager.show_dialogue_balloon(load("res://dialogue/puzzle_backyard_done.dialogue"), "start")
	
	
func _exit_tree() -> void:
	SignalManager.outside.emit(false) # for sound purposes

func _on_breaker_2_puzzle_start() -> void:
	SignalManager.puzzle_mode.emit()
