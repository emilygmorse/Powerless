extends ROOM

#See func puzzled_solved TO DOs (likely not done in that function)

@onready var light_source_circle: PointLight2D = $LightSourceCircle
@onready var enemy_spawner: Node2D = $EnemySpawner

func _ready() -> void:
	room_light_status(GameManager.puzzle_1_solved)
	SignalManager.mid_dialogue.connect(mid_dialogue)
	SignalManager.puzzle_solved.connect(puzzle_solved)
	#SignalManager.puzzle_mode.connect(puzzle_mode)

	if GameManager.puzzle_intro:
		light_source_circle.queue_free()
		
	if GameManager.puzzle_1_solved:
		$EnemySpawner.queue_free()
		$Breaker.set_monitorable(false)
	elif GameManager.puzzle_intro:
		$EnemySpawner.spawn_enemy()
	
	if GameManager.kitchen_intro == false:    #UPDATE THIS LINE W/ CORRECT ROOM
		create_dialogue_balloon()
		get_tree().create_timer(0.1).timeout.connect(intro_dialogue)

func intro_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_kitchen.dialogue"), "start")

func mid_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/mid_kitchen.dialogue"), "start")

#func puzzle_mode() -> void:
	#print("puzzle 1 show!")
	##add_puzzle(puzzle_1)
	#light_source_circle.hide()

func puzzle_solved() -> void:
	enemy_spawner.queue_free()
	GameManager.puzzle_1_solved = true
	GameManager.current_checkpoint = 1
	SignalManager.destroy_enemies.emit()
	room_light_status(GameManager.puzzle_1_solved)
	$Breaker.set_monitorable(false)
	DialogueManager.show_dialogue_balloon(load("res://dialogue/puzzle_kitchen_done.dialogue"), "start")
	#TODO: Checkpoint updated to Kitchen door entry to yard

func spawner_check() -> void: 
	if GameManager.puzzle_intro or GameManager.puzzle_1_solved == false:
		SignalManager.activate_enemy_spawner.emit()

func _on_breaker_puzzle_start() -> void:
	print("breaker area entered")
	if GameManager.puzzle_intro == true:
		SignalManager.puzzle_mode.emit()
	else:
		light_source_circle.hide()
		DialogueManager.show_dialogue_balloon(load("res://dialogue/puzzle_kitchen.dialogue"), "start")
