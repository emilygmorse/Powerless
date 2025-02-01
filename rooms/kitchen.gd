extends ROOM

@onready var puzzle_1: Node2D = $Puzzle1

func _ready() -> void:
	SignalManager.light_check.emit(false) #TEST
	
	SignalManager.mid_dialogue.connect(mid_dialogue)
	SignalManager.puzzle_mode.emit(puzzle_mode)
	room_light_status(GameManager.puzzle_1_solved)
	
	if GameManager.kitchen_intro == false:    #UPDATE THIS LINE W/ CORRECT ROOM
		create_dialogue_balloon()
		get_tree().create_timer(0.1).timeout.connect(intro_dialogue)

func intro_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_kitchen.dialogue"), "start")

func mid_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/mid_kitchen.dialogue"), "start")

func puzzle_mode() -> void:
	puzzle_1.show()

func _on_breaker_area_area_entered(area: Area2D) -> void:
	print("breaker area entered")
	if GameManager.puzzle_intro == true:
		puzzle_mode()
	else:
		DialogueManager.show_dialogue_balloon(load("res://dialogue/puzzle_kitchen.dialogue"), "start")
