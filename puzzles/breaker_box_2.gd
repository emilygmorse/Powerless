extends Node2D

var click_delay: bool = false
var top_breaker_avail: bool = false

@onready var switch_top: ColorRect = $BreakerTop/SwitchTop
@onready var indicator_top: ColorRect = $BreakerTop/IndicatorTop
@onready var switch_left_1: ColorRect = $BreakerLeft1/SwitchLeft1
@onready var indicator_left_1: ColorRect = $BreakerLeft1/IndicatorLeft1
@onready var switch_left_2: ColorRect = $BreakerLeft2/SwitchLeft2
@onready var indicator_left_2: ColorRect = $BreakerLeft2/IndicatorLeft2
@onready var switch_left_3: ColorRect = $BreakerLeft3/SwitchLeft3
@onready var indicator_left_3: ColorRect = $BreakerLeft3/IndicatorLeft3
@onready var switch_left_4: ColorRect = $BreakerLeft4/SwitchLeft4
@onready var indicator_left_4: ColorRect = $BreakerLeft4/IndicatorLeft4
@onready var switch_right_1: ColorRect = $BreakerRight1/SwitchRight1
@onready var indicator_right_1: ColorRect = $BreakerRight1/IndicatorRight1
@onready var switch_right_2: ColorRect = $BreakerRight2/SwitchRight2
@onready var indicator_right_2: ColorRect = $BreakerRight2/IndicatorRight2
@onready var switch_right_3: ColorRect = $BreakerRight3/SwitchRight3
@onready var indicator_right_3: ColorRect = $BreakerRight3/IndicatorRight3

var breaker_top = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_left_1 = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_left_2 = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_left_3 = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_left_4 = {"tripped": true, "switch_pos_x_shift": 13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_right_1 = {"tripped": true, "switch_pos_x_shift": -13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_right_2 = {"tripped": true, "switch_pos_x_shift": -13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}
var breaker_right_3 = {"tripped": true, "switch_pos_x_shift": -13, "switch_trip_pos_x": 0, "ind_trip_pos_x": 0}

func _ready() -> void:
	set_positions(breaker_top, switch_top, indicator_top)
	set_positions(breaker_left_1, switch_left_1, indicator_left_1)
	set_positions(breaker_left_2, switch_left_2, indicator_left_2)
	set_positions(breaker_left_3, switch_left_3, indicator_left_3)
	set_positions(breaker_left_4, switch_left_4, indicator_left_4)
	set_positions(breaker_right_1, switch_right_1, indicator_right_1)
	set_positions(breaker_right_2, switch_right_2, indicator_right_2)
	set_positions(breaker_right_3, switch_right_3, indicator_right_3)

func set_positions(breaker: Dictionary, switch: ColorRect, indicator: ColorRect) -> void:
	breaker.switch_trip_pos_x = switch.position.x
	breaker.ind_trip_pos_x = indicator.position.x

func switch_function(breaker: Dictionary, switch: ColorRect, indicator: ColorRect) -> void:
	if breaker.tripped == false:
		breaker.tripped = true
		switch.position.x = breaker.switch_trip_pos_x
		indicator.position.x = breaker.ind_trip_pos_x
		indicator.color = Color.CRIMSON
	elif breaker.tripped == true:
		breaker.tripped = false
		switch.position.x = breaker.switch_trip_pos_x + breaker.switch_pos_x_shift
		indicator.position.x = breaker.ind_trip_pos_x - breaker.switch_pos_x_shift
		indicator.color = Color.FOREST_GREEN

func click_delay_off() -> void:
	click_delay = false

func _on_breaker_top_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_top, switch_top, indicator_top)

		#if breaker_left_1.tripped == false:
			#if breaker_left_2.tripped == false:
				#if breaker_left_3.tripped == false:
					#if breaker_left_4.tripped == false:
						#if breaker_right_1.tripped == false:
							#if breaker_right_2.tripped == false:
								#if breaker_right_3.tripped == false:
									#top_breaker_avail = true
									#switch_function(breaker_top, switch_top, indicator_top)
		#else:
			#print("oops no dice")
		

func _on_breaker_left_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_left_1, switch_left_1, indicator_left_1)


func _on_breaker_left_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_left_2, switch_left_2, indicator_left_2)


func _on_breaker_left_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_left_3, switch_left_3, indicator_left_3)


func _on_breaker_left_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_left_4, switch_left_4, indicator_left_4)


func _on_breaker_right_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_right_1, switch_right_1, indicator_right_1)


func _on_breaker_right_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_right_2, switch_right_2, indicator_right_2)


func _on_breaker_right_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false:
		click_delay = true
		get_tree().create_timer(0.2).timeout.connect(click_delay_off)
		switch_function(breaker_right_3, switch_right_3, indicator_right_3)
