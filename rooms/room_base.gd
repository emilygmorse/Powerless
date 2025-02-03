extends Node2D

class_name ROOM

var light_status
var current_puzzle
const SPOOCCESS = preload("res://sounds/music/Spooccess.wav")

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var dark_canvas: CanvasModulate = $dark_canvas

func create_dialogue_balloon() -> void:
	var balloon = load("res://dialogue/balloon.tscn").instantiate()
	get_tree().current_scene.add_child.call_deferred(balloon)

func play_win():
	audio_stream_player_2d.set_stream(SPOOCCESS)
	audio_stream_player_2d.play()
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
		print("Light status: true set in room_light_status")
		SignalManager.theme_music.emit(true)
	else:
		SignalManager.light_check.emit(false)
		print("Light status: false set in room_light_status")
		SignalManager.ambient_music.emit(true)
