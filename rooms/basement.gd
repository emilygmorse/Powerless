extends ROOM

@onready var cover_key: Sprite2D = $CoverKey


func _ready() -> void:
	room_light_status(GameManager.puzzle_2_solved)
	SignalManager.got_key.connect(got_key)
	
	if GameManager.puzzle_2_solved:
		$EnemySpawner.queue_free()
	elif GameManager.basement_intro == false and GameManager.puzzle_2_solved == false:   
		create_dialogue_balloon()
		get_tree().create_timer(0.1).timeout.connect(intro_dialogue)
		$EnemySpawner.spawn_enemy()
	else:
		$EnemySpawner.spawn_enemy()

func intro_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/basement_intro.dialogue"), "start")

func got_key():
	cover_key.show()
	GameManager.attic_key = true
