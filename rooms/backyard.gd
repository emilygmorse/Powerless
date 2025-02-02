extends ROOM


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.outside.emit(true)



func _exit_tree() -> void:
	SignalManager.outside.emit(false)
