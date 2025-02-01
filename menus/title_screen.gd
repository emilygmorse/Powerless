extends Control

signal play_game
signal goto_options
signal quit_game

func _on_play_button_pressed() -> void:
	play_game.emit()


func _on_options_button_pressed() -> void:
	goto_options.emit()


func _on_quit_button_pressed() -> void:
	quit_game.emit()
