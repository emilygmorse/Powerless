class_name Interactable extends Area2D

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

signal pick_up_teddy
signal pop_up

func _emit_pick_up_teddy_signal():
	pick_up_teddy.emit()
	print("emitted signal")

func _emit_pop_up_signal():
	pop_up.emit()
	print("emitted popup signal")
