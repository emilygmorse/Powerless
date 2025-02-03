extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.tut_puzzle.connect(transition_in)
	#SignalManager.puzzle_solved.connect(transition_out)
	

func transition_in():
	animation_player.play("transition")


#func transition_out():
	#animation_player.play_backwards("transition")
