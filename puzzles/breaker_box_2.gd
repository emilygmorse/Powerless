extends Node2D

var click_delay: bool = false
var top_breaker_avail: bool = false

const BREAKER_OPEN = preload("res://sounds/recorded effects/wavfiles/breaker_open.wav")
const BREAKER_CLOSE = preload("res://sounds/recorded effects/wavfiles/breaker_close.wav")
@onready var click: AudioStreamPlayer = $Click


@onready var switch_top: ColorRect = $BreakerTop/SwitchTop
@onready var indicator_top: ColorRect = $BreakerTop/IndicatorTop
@onready var switch_left_2: ColorRect = $BreakerLeft2/SwitchLeft2
@onready var indicator_left_2: ColorRect = $BreakerLeft2/IndicatorLeft2
@onready var switch_left_3: ColorRect = $BreakerLeft3/SwitchLeft3
@onready var indicator_left_3: ColorRect = $BreakerLeft3/IndicatorLeft3
@onready var switch_left_4: ColorRect = $BreakerLeft4/SwitchLeft4
@onready var indicator_left_4: ColorRect = $BreakerLeft4/IndicatorLeft4
@onready var switch_right_2: ColorRect = $BreakerRight2/SwitchRight2
@onready var indicator_right_2: ColorRect = $BreakerRight2/IndicatorRight2
@onready var switch_right_3: ColorRect = $BreakerRight3/SwitchRight3
@onready var indicator_right_3: ColorRect = $BreakerRight3/IndicatorRight3

var breaker_top = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_left_2 = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_left_3 = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_left_4 = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_right_2 = {"tripped": true, "switch_pos_x_shift": -13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_right_3 = {"tripped": true, "switch_pos_x_shift": -13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}

func _ready() -> void:
	GameManager.breaker_tripped_2 = true
	SignalManager.breaker_box_toggle.connect(toggle)
	SignalManager.wires_shorted.connect(trip_all_breakers)
	SignalManager.breaker_switches_set.emit()
	set_positions(breaker_top, switch_top, indicator_top)
	set_positions(breaker_left_2, switch_left_2, indicator_left_2)
	set_positions(breaker_left_3, switch_left_3, indicator_left_3)
	set_positions(breaker_left_4, switch_left_4, indicator_left_4)
	set_positions(breaker_right_2, switch_right_2, indicator_right_2)
	set_positions(breaker_right_3, switch_right_3, indicator_right_3)

func toggle(display: bool) -> void:
	if display:
		self.show()
	else:
		self.hide()

func set_positions(breaker: Dictionary, switch: ColorRect, indicator: ColorRect) -> void:
	breaker.switch_trip_pos_x = switch.position.x
	breaker.ind_trip_pos_x = indicator.position.x

func switch_function(breaker: Dictionary, switch: ColorRect, indicator: ColorRect) -> void:
	if breaker.tripped == false:
		breaker.tripped = true
		switch.position.x = breaker.switch_trip_pos_x
		indicator.position.x = breaker.ind_trip_pos_x
		indicator.color = Color.CRIMSON
		click.set_stream(BREAKER_CLOSE)
		click.play()
	elif breaker.tripped == true:
		breaker.tripped = false
		switch.position.x = breaker.switch_trip_pos_x + breaker.switch_pos_x_shift
		indicator.position.x = breaker.ind_trip_pos_x - breaker.switch_pos_x_shift
		indicator.color = Color.FOREST_GREEN
		click.set_stream(BREAKER_OPEN)
		click.play()

func trip_function(breaker: Dictionary, switch: ColorRect, indicator: ColorRect) -> void:
		breaker.tripped = true
		switch.position.x = breaker.switch_trip_pos_x
		indicator.position.x = breaker.ind_trip_pos_x
		indicator.color = Color.CRIMSON
		click.set_stream(BREAKER_CLOSE)
		click.play()

func click_delay_off() -> void:
	click_delay = false
	
func trip_all_breakers() -> void:
	trip_function(breaker_top, switch_top, indicator_top)
	trip_function(breaker_left_2, switch_left_2, indicator_left_2)
	trip_function(breaker_left_3, switch_left_3, indicator_left_3)
	trip_function(breaker_left_4, switch_left_4, indicator_left_4)
	trip_function(breaker_right_2, switch_right_2, indicator_right_2)
	trip_function(breaker_right_3, switch_right_3, indicator_right_3)

func _on_breaker_top_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		#switch_function(breaker_top, switch_top, indicator_top)

		if breaker_left_2.tripped == false:
			if breaker_left_3.tripped == false:
				if breaker_left_4.tripped == false:
					if breaker_right_2.tripped == false:
						if breaker_right_3.tripped == false:
							top_breaker_avail = true
							switch_function(breaker_top, switch_top, indicator_top)
							SignalManager.breaker_switches_set.emit()
		else:
			trip_all_breakers()
			click.set_stream(BREAKER_CLOSE)
			click.play()

#Good
func _on_breaker_left_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		if breaker_right_3.tripped == false:
			switch_function(breaker_left_2, switch_left_2, indicator_left_2)
		else:
			trip_all_breakers()
#Good
func _on_breaker_left_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		if breaker_left_2.tripped == false:
			switch_function(breaker_left_3, switch_left_3, indicator_left_3)
		else:
			trip_all_breakers()

func _on_breaker_left_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		if breaker_left_3.tripped == false:
			switch_function(breaker_left_4, switch_left_4, indicator_left_4)
		else:
			trip_all_breakers()
#Good
func _on_breaker_right_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_right_2, switch_right_2, indicator_right_2)

#Good
func _on_breaker_right_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		if breaker_right_2.tripped == false:
			switch_function(breaker_right_3, switch_right_3, indicator_right_3)
		else:
			trip_all_breakers()
