extends Node

const GAME = "res://game.tscn"

var game:Node #the game scene
var gaming := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the game after Godot starts up
	ResourceLoader.load_threaded_request(GAME)
	$TitleMusic.play()

func _on_title_screen_goto_options() -> void:
	$Options.show()


func _on_title_screen_play_game() -> void:
	var load_status = ResourceLoader.load_threaded_get_status(GAME)
	# If the room has finished loading
	if load_status == 3:
		$TitleMusic.stop()
		game = ResourceLoader.load_threaded_get(GAME).instantiate()
		self.add_child(game)
		$TitleScreen.hide()
		gaming = true
	else:
		print("not loaded. loader status: ",load_status)
		#TODO: Implement a loading screen here if necessary


func _on_title_screen_quit_game() -> void:
	get_tree().quit()

func _unhandled_key_input(event: InputEvent) -> void:
	#Pause button
	if event.is_action_pressed("pause") and gaming:
		$Pause.show()
		get_tree().paused = true


func _on_pause_quit_to_title() -> void:
	game.queue_free()
	self.remove_child(game)
	$TitleScreen.show()
	$TitleMusic.play()
	gaming = false
