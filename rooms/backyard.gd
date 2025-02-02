extends ROOM

@onready var puzzle_2: Node2D = $Puzzle2
@onready var light_source_circle: PointLight2D = $LightSourceCircle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.outside.emit(true)
	room_light_status(false)
	SignalManager.puzzle_mode.connect(puzzle_mode)
	SignalManager.puzzle_solved.connect(puzzle_solved)

func puzzle_mode() -> void:
	add_puzzle(puzzle_2)

func puzzle_solved() -> void:
	remove_puzzle(puzzle_2)
	GameManager.puzzle_2_solved = true
	#Dialogue entry. Seems the key to the cellar is missing from its usual spot.
	#Interaction available to discover the key somewhere within the yard
	
func _exit_tree() -> void:
	SignalManager.outside.emit(false)

func _on_breaker_2_puzzle_start() -> void:
	puzzle_mode()
