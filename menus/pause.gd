extends Control

signal quit_to_title

func _on_continue_button_pressed() -> void:
	self.hide()
	get_tree().paused = false


func _on_options_button_pressed() -> void:
	$Options.show()


func _on_quit_button_pressed() -> void:
	self.hide()
	get_tree().paused = false
	quit_to_title.emit()
