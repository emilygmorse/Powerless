extends Node2D

const AVG_TIME := 90.0 #seconds
const VAR_TIME := 30.0 #seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prep_creak()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func prep_creak() -> void:
	$CreakTimer.start(AVG_TIME + randf_range(-1.0,1.0)*VAR_TIME)

func _on_creak_timer_timeout() -> void:
	$Creaking.play()
	prep_creak()

func stop_creak() -> void:
	$CreakTimer.stop()
