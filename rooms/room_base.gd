extends Node2D

class_name ROOM

var light_status
var current_puzzle

@onready var dark_canvas: CanvasModulate = $dark_canvas

func create_dialogue_balloon() -> void:
	var balloon = load("res://dialogue/balloon.tscn").instantiate()
	get_tree().current_scene.add_child.call_deferred(balloon)

#func add_puzzle(puzzle: Node2D) -> void:
	#puzzle.show()
	#
#func remove_puzzle(puzzle: Node2D) -> void:
	#get_tree().create_timer(1.1).timeout.connect(delete_puzzle)
#
#func delete_puzzle(puzzle: Node2D) -> void:
	#puzzle.queue_free()
	
func room_light_status(condition: bool) -> void:
	if condition:
		dark_canvas.hide()
		light_status = true
	else:
		dark_canvas.show()
		light_status = false
	get_tree().create_timer(0.1).timeout.connect(light_signal)

func light_signal() -> void:
	if light_status:
		SignalManager.light_check.emit(true)
	else:
		SignalManager.light_check.emit(false)
