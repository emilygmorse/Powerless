extends Node2D

const AVG_TIME := 90.0 #seconds
const VAR_TIME := 30.0 #seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.outside.connect(went_outside)
	SignalManager.ambient_music.connect(ambient)
	prep_creak()


func prep_creak() -> void:
	$CreakTimer.start(AVG_TIME + randf_range(-1.0,1.0)*VAR_TIME)

func _on_creak_timer_timeout() -> void:
	$Creaking.play()
	prep_creak()

func stop_creak() -> void:
	$CreakTimer.stop()

func went_outside(yes):
	if yes:
		stop_creak()
	else:
		prep_creak()

func ambient(on: bool):
	if on:
		$AmbientMusic.play()
	else:
		$AmbientMusic.stop()
