extends Node2D


func _ready() -> void:
	SignalManager.instr_toggle.connect(toggle)
	
	SignalManager.tut_breaker.connect(hide)
	SignalManager.tut_wire.connect(hide)
	SignalManager.tut_instructions.connect(show)
	
func toggle(display: bool) -> void:
	if display:
		self.show()
	else:
		self.hide()
