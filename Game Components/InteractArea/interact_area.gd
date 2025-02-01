class_name Interactable extends Area2D

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

signal pick_up_teddy
signal pop_up
signal puzzle_start

func _emit_pick_up_teddy_signal(kid):
	# Emitting kid so Teddy can follow
	pick_up_teddy.emit(kid)
	#print("emitted signal",kid)

func _emit_pop_up_signal():
	pop_up.emit()
	#print("emitted popup signal")

func _emit_puzzle_start():
	puzzle_start.emit()
