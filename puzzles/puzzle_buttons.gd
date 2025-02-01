extends Control

@onready var instr_button: TextureButton = $InstrButton
@onready var break_button: TextureButton = $BreakButton
@onready var wire_button: TextureButton = $WireButton


func _on_instr_button_pressed() -> void:
	SignalManager.instr_toggle.emit(true)
	SignalManager.breaker_box_toggle.emit(false)
	SignalManager.wire_puzzle_toggle.emit(false)
	instr_button.disabled = true
	break_button.disabled = false
	wire_button.disabled = false

func _on_break_button_pressed() -> void:
	SignalManager.breaker_box_toggle.emit(true)
	SignalManager.instr_toggle.emit(false)
	SignalManager.wire_puzzle_toggle.emit(false)
	break_button.disabled = true
	instr_button.disabled = false
	wire_button.disabled = false


func _on_wire_button_pressed() -> void:
	SignalManager.wire_puzzle_toggle.emit(true)
	SignalManager.breaker_box_toggle.emit(false)
	SignalManager.instr_toggle.emit(false)
	wire_button.disabled = true
	break_button.disabled = false
	instr_button.disabled = false
