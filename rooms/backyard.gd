extends ROOM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.outside.emit(true) # for sound purposes
	room_light_status(false)
	SignalManager.puzzle_solved.connect(puzzle_solved)
	$EnemySpawner.spawn_enemy()
	if GameManager.puzzle_2_solved:
		$Breaker2.set_monitorable(false)

func puzzle_solved() -> void:
	win_jangle.play()
	GameManager.puzzle_2_solved = true
	$Breaker2.set_monitorable(false)
	#Dialogue entry. 
	#Interaction available to discover the key somewhere within the yard
	
func _exit_tree() -> void:
	SignalManager.outside.emit(false) # for sound purposes

func _on_breaker_2_puzzle_start() -> void:
	SignalManager.puzzle_mode.emit()
