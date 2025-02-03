extends TextureProgressBar


func _on_value_changed(val: float) -> void:
	if val == max_value:
		SignalManager.max_fear_reached.emit()
