extends ROOM

#See func puzzled_solved TO DOs (likely not done in that function)

@onready var puzzle_1: Node2D = $Puzzle1
@onready var light_source_circle: PointLight2D = $LightSourceCircle
@onready var enemy_spawner: Node2D = $EnemySpawner

func _ready() -> void:
	room_light_status(GameManager.puzzle_1_solved)
	SignalManager.mid_dialogue.connect(mid_dialogue)
	SignalManager.puzzle_mode.connect(puzzle_mode)
	SignalManager.puzzle_solved.connect(puzzle_solved)
	SignalManager.activate_enemy_spawner.emit()
	
	if GameManager.kitchen_intro == false:    #UPDATE THIS LINE W/ CORRECT ROOM
		create_dialogue_balloon()
		get_tree().create_timer(0.1).timeout.connect(intro_dialogue)

func intro_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_kitchen.dialogue"), "start")

func mid_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/mid_kitchen.dialogue"), "start")

func puzzle_mode() -> void:
	print("puzzle 1 show!")
	add_puzzle(puzzle_1)
	light_source_circle.hide()

func puzzle_solved() -> void:
	remove_puzzle(puzzle_1)
	enemy_spawner.queue_free()
	GameManager.puzzle_1_solved = true
	SignalManager.destroy_enemies.emit()
	room_light_status(GameManager.puzzle_1_solved)
	#Dialogue entry. Now that we can see the padlock on the yard door, we can go out back
	#Suggest we turn on the backyard power
	#Yard door now accessible
	#Checkpoint updated to Kitchen door entry to yard

func spawner_check() -> void: 
	if GameManager.puzzle_intro or GameManager.puzzle_1_solved == false:
		SignalManager.activate_enemy_spawner.emit()

func _on_breaker_puzzle_start() -> void:
	print("breaker area entered")
	if GameManager.puzzle_intro == true:
		puzzle_mode()
	else:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/puzzle_kitchen.dialogue"), "start")
