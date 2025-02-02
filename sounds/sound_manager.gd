extends Node2D

const AVG_TIME := 90.0 #seconds
const VAR_TIME := 30.0 #seconds
var end:= false
var vol := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.outside.connect(went_outside)
	SignalManager.ambient_music.connect(ambient)
	SignalManager.theme_music.connect(theme)
	SignalManager.end_game.connect(game_end)
	prep_creak(AVG_TIME / 2.0 + randf_range(-1.0,1.0)*VAR_TIME)
	prep_thump(AVG_TIME / 2.0 + randf_range(-1.0,1.0)*VAR_TIME)
	prep_sus(AVG_TIME / 2.0 + randf_range(-1.0,1.0)*VAR_TIME)

func _process(delta: float) -> void:
	if end:
		vol = vol - 0.0005
		if vol > 0:
			$ThemeMusic.set_volume_db(linear_to_db(vol))
		else:
			end = false

func prep_creak(time:=0.0) -> void:
	if time > 0:
		$CreakTimer.start(time)
	else:
		$CreakTimer.start(AVG_TIME + randf_range(-1.0,1.0)*VAR_TIME)

func _on_creak_timer_timeout() -> void:
	$Creaking.play()
	prep_creak()

func stop_creak() -> void:
	$CreakTimer.stop()

func prep_thump(time:=0.0) -> void:
	if time > 0:
		$ThumpTimer.start(time)
	else:
		$ThumpTimer.start(AVG_TIME + randf_range(-1.0,1.0)*VAR_TIME)

func _on_thump_timer_timeout() -> void:
	$Thumps.play()
	prep_thump()

func stop_thump() -> void:
	$ThumpTimer.stop()

func went_outside(yes):
	if yes:
		stop_creak()
		stop_thump()
	else:
		prep_creak(AVG_TIME / 2.0 + randf_range(-1.0,1.0)*VAR_TIME)
		prep_thump(AVG_TIME / 2.0 + randf_range(-1.0,1.0)*VAR_TIME)

func prep_sus(time:=0.0) -> void:
	if time > 0:
		$SusTimer.start(time)
	else:
		$SusTimer.start(AVG_TIME + randf_range(-1.0,1.0)*VAR_TIME)

func _on_sus_timer_timeout() -> void:
	$SusNoises.play()
	prep_sus()

func ambient(on: bool):
	if on:
		if not $AmbientMusic.is_playing():
			$ThemeMusic.stop()
			$AmbientMusic.play()
	else:
		$AmbientMusic.stop()

func theme(on: bool):
	if on:
		if not $ThemeMusic.is_playing():
			$AmbientMusic.stop()
			$ThemeMusic.play()
	else:
		$ThemeMusic.stop()

func stop_sounds() -> void:
	stop_thump()
	stop_creak()
	$SusTimer.stop()

func game_end() -> void:
	end = true
	vol = db_to_linear($ThemeMusic.get_volume_db())
	stop_sounds()
