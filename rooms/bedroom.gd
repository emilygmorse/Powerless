extends ROOM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	SignalManager.light_check.emit(true) #TEST
	
	if GameManager.bedroom_intro == false:
		create_dialogue_balloon()
		get_tree().create_timer(0.1).timeout.connect(intro_dialogue)

func intro_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_bedroom.dialogue"), "start")
