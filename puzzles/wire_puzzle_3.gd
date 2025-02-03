extends Node2D

var click_delay: bool = false
var previous_wire = null
var current_wire = null

#Operates in tandem with GameManager var breaker_trip_1

var bottom_wire_1 = {"name": "BW1", "solution": "TW1", "active": false}
var bottom_wire_2 = {"name": "BW2", "solution": "TW3", "active": false}
var bottom_wire_3 = {"name": "BW3", "solution": "TW5", "active": false}
var bottom_wire_4 = {"name": "BW4", "solution": "TW2", "active": false}
var bottom_wire_5 = {"name": "BW5", "solution": "TW4", "active": false}


var top_wire_1 = {"name": "TW1", "solution": "BW1", "active": false}
var top_wire_2 = {"name": "TW2", "solution": "BW4", "active": false}
var top_wire_3 = {"name": "TW3", "solution": "BW2", "active": false}
var top_wire_4 = {"name": "TW4", "solution": "BW5", "active": false}
var top_wire_5 = {"name": "TW5", "solution": "BW3", "active": false}

@onready var spark_bw_1: AnimatedSprite2D = $BottomWire1/SparkBW1
@onready var spark_bw_2: AnimatedSprite2D = $BottomWire2/SparkBW2
@onready var spark_bw_3: AnimatedSprite2D = $BottomWire3/SparkBW3
@onready var spark_bw_4: AnimatedSprite2D = $BottomWire4/SparkBW4
@onready var spark_bw_5: AnimatedSprite2D = $BottomWire5/SparkBW5

@onready var spark_tw_1: AnimatedSprite2D = $TopWire1/SparkTW1
@onready var spark_tw_2: AnimatedSprite2D = $TopWire2/SparkTW2
@onready var spark_tw_3: AnimatedSprite2D = $TopWire3/SparkTW3
@onready var spark_tw_4: AnimatedSprite2D = $TopWire4/SparkTW4
@onready var spark_tw_5: AnimatedSprite2D = $TopWire5/SparkTW5


func _ready() -> void:
	short_all_wires()
	SignalManager.wire_puzzle_toggle.connect(toggle)
	SignalManager.breaker_switches_set.connect(all_wires_live)
	all_wires_live()

func toggle(display: bool) -> void:
	if display:
		self.show()
	else:
		self.hide()

func _process(_delta: float) -> void:
	win_condition()

func click_delay_off() -> void:
	click_delay = false

func wire_updates(wire: Dictionary, spark: AnimatedSprite2D):
		current_wire = wire.name
		if previous_wire == null:
			spark.play()
			wire.active = true
			previous_wire = wire.name
		elif previous_wire == wire.name:
			spark.stop()
			wire.active = false
			previous_wire = null
		elif previous_wire == wire.solution:
			spark.play()
			wire.active = true
			previous_wire = null
		else:
			GameManager.breaker_tripped_3 = true
			previous_wire = null
			short_all_wires()
			SignalManager.wires_shorted.emit()

func wires_shorted(wire: Dictionary, spark: AnimatedSprite2D)-> void:
	spark.stop()
	spark.hide()
	wire.active = false

func short_all_wires() -> void:
	wires_shorted(bottom_wire_1, spark_bw_1)
	wires_shorted(bottom_wire_2, spark_bw_2)
	wires_shorted(bottom_wire_3, spark_bw_3)
	wires_shorted(bottom_wire_4, spark_bw_4)
	wires_shorted(bottom_wire_5, spark_bw_5)


	wires_shorted(top_wire_1, spark_tw_1)
	wires_shorted(top_wire_2, spark_tw_2)
	wires_shorted(top_wire_3, spark_tw_3)
	wires_shorted(top_wire_4, spark_tw_4)
	wires_shorted(top_wire_5, spark_tw_5)

func all_wires_live() -> void:
	GameManager.breaker_tripped_3 = false
	spark_bw_1.show()
	spark_bw_2.show()
	spark_bw_3.show()
	spark_bw_4.show()
	spark_bw_5.show()
	spark_tw_1.show()
	spark_tw_2.show()
	spark_tw_3.show()
	spark_tw_4.show()
	spark_tw_5.show()

func win_condition() -> void:
	if GameManager.wire_puzzle_solved_3 == false:
		if bottom_wire_1.active:
			if bottom_wire_2.active:
				if bottom_wire_3.active:
					if bottom_wire_4.active:
						if bottom_wire_5.active:
							if top_wire_1.active:
								if top_wire_2.active:
									if top_wire_3.active:
										if top_wire_4.active:
											if top_wire_5.active:
												GameManager.wire_puzzle_solved_3 = true
												SignalManager.puzzle_solved.emit()



func _on_bottom_wire_1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(bottom_wire_1, spark_bw_1)


func _on_bottom_wire_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(bottom_wire_2, spark_bw_2)


func _on_bottom_wire_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(bottom_wire_3, spark_bw_3)


func _on_top_wire_1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(top_wire_1, spark_tw_1)


func _on_top_wire_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(top_wire_2, spark_tw_2)


func _on_top_wire_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(top_wire_3, spark_tw_3)


func _on_bottom_wire_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(bottom_wire_4, spark_bw_4)


func _on_top_wire_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(top_wire_4, spark_tw_4)


func _on_bottom_wire_5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(bottom_wire_5, spark_bw_5)


func _on_top_wire_5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and click_delay == false
	and GameManager.breaker_tripped_3 == false and GameManager.wire_puzzle_solved_3 == false):
		click_delay = true
		get_tree().create_timer(0.5).timeout.connect(click_delay_off)
		wire_updates(top_wire_5, spark_tw_5)
