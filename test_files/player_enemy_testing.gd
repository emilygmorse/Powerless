extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(3.0).timeout.connect(begin_dialogue)


func begin_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogue/test.dialogue"), "start")
