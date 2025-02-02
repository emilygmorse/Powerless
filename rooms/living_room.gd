extends ROOM

func _ready() -> void:
	room_light_status(GameManager.puzzle_1_solved)
	if GameManager.living_room_intro == false:
		create_dialogue_balloon()
		get_tree().create_timer(0.1).timeout.connect(intro_dialogue)
	else:
		$EnemySpawner.spawn_enemy()

func intro_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_living_room.dialogue"), "start")
