class_name Interactable extends Area2D

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

signal pick_up_teddy

func _emit_pick_up_teddy_signal():
	pick_up_teddy.emit()
	print("emitted signal")
