extends Node2D

class_name ROOM

@onready var dark_canvas: CanvasModulate = $dark_canvas

func create_dialogue_balloon() -> void:
	var balloon = load("res://dialogue/balloon.tscn").instantiate()
	get_tree().current_scene.add_child.call_deferred(balloon)

func room_light_status(condition: bool) -> void:
	if condition:
		dark_canvas.hide()
		SignalManager.light_check.emit(true)
	else:
		SignalManager.light_check.emit(false)
