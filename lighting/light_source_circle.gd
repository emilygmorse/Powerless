extends PointLight2D

var room_is_lit = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SignalManager.light_check.emit(true)
		print("Light signal: true set in PointLight")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not room_is_lit and body.is_in_group("Player"):
		SignalManager.light_check.emit(false)
		print("Light signal: false set in PointLight")
