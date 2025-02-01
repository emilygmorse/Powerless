extends PointLight2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.light_check.emit(true)

func _on_area_2d_area_exited(area: Area2D) -> void:
	SignalManager.light_check.emit(false)
