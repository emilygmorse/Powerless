extends ROOM


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_light_status(GameManager.puzzle_2_solved)
