extends Control


func _on_back_button_pressed() -> void:
	self.hide()


func _on_controls_button_pressed() -> void:
	$InputRemapMenu.show()
