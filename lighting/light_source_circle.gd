extends PointLight2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	SignalManager.light_check.emit(true)
	print("Light signal: true set in PointLight")


func _on_area_2d_body_exited(body: Node2D) -> void:
	SignalManager.light_check.emit(false)
	print("Light signal: false set in PointLight")
