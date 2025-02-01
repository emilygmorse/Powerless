extends Node2D


func _ready() -> void:
	SignalManager.instr_toggle.connect(toggle)

func toggle(display: bool) -> void:
	if display:
		self.show()
	else:
		self.hide()
