extends ROOM

func _ready() -> void:
	SignalManager.light_check.emit(false) #TEST
	
	if GameManager.living_room_intro == false:
		create_dialogue_balloon()
		get_tree().create_timer(0.1).timeout.connect(intro_dialogue)
	else: SignalManager.activate_enemy_spawner.emit()

func intro_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_living_room.dialogue"), "start")
