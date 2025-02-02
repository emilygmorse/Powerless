extends CharacterBody2D

const SPEED = 70.0
var inputs_allowed = true
var has_teddy = false
var puzzle_mode = false
var meter_pause = false

@onready var all_interactions = []
@onready var interact_label = $"Interaction Components/Interact Label"
@onready var hurt_box: Area2D = $HurtBox
@onready var fearMeter = $"../FearMeter"
#@onready var current_room: ROOM = find_room(self.get_parent, ROOM)
@export var player_fear: int = 0
@export var in_light_index = 0

signal door(door_info: String)
signal hurt_box_hit

func _ready() -> void:
	SignalManager.cutscene_started.connect(cutscene_started)
	SignalManager.cutscene_ended.connect(cutscene_ended)
	SignalManager.light_check.connect(light_check)
	SignalManager.puzzle_mode.connect(puzzle_mode_timer)
	SignalManager.puzzle_solved.connect(puzzle_solved)

	$AnimatedSprite2D.play()
	SignalManager.hit_player.connect(update_fear)
	update_interactions()

func cutscene_started() -> void:
	inputs_disabled()
	meter_pause = true

func cutscene_ended() -> void:
	inputs_enabled()
	meter_pause = false

func inputs_disabled() -> void:
	inputs_allowed = false
	$AnimatedSprite2D.animation = "idle"

func inputs_enabled() -> void:
	get_tree().create_timer(0.01).timeout.connect(inputs_enabled_timer)

func inputs_enabled_timer() -> void:
	inputs_allowed = true


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement
	if inputs_allowed == true:
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		velocity = input_dir * SPEED
		
		if velocity.length() == 0:
			$AnimatedSprite2D.animation = "idle"
		elif velocity.x < 0:
			$AnimatedSprite2D.animation = "walk_left"
		elif velocity.x > 0: 
			$AnimatedSprite2D.animation = "walk_right"
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "walk_down"
		elif velocity.y < 0: 
			$AnimatedSprite2D.animation = "walk_up"
		
		move_and_slide()
	elif puzzle_mode == true:
		$AnimatedSprite2D.animation = "puzzle"
	else:
		$AnimatedSprite2D.animation = "idle"
		
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and inputs_allowed:
		execute_interaction()

func find_room(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null

#Fear/health methods
func update_fear(damage: int) -> void:
	print("Player fear before decrease {}", player_fear)
	player_fear += damage
	print("Player fear after decrease {}", player_fear)
	print("Fear meter value before decrease {}", fearMeter.value)
	fearMeter.value = player_fear
	print("Fear meter value after decrease {}", fearMeter.value)
	

func light_check(standing_in_light : bool):	
	if standing_in_light:
		in_light_index = -15
	else:
		in_light_index = 1
		


func _on_fear_increased():
	fearMeter.value += 10

func puzzle_mode_timer():
	get_tree().create_timer(0.01).timeout.connect(puzzle_mode_activate)

func puzzle_mode_activate():
	print("puzzle mode")
	inputs_disabled()
	$AnimatedSprite2D.animation = "puzzle"
	puzzle_mode = true

func puzzle_solved():
	puzzle_mode = false
	has_teddy = true
	inputs_enabled()

##Interaction Methods

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		interact_label.text = all_interactions[0].interact_label
	else: 
		interact_label.text = ""
		
func execute_interaction():
	if all_interactions:
		var cur_interactions = all_interactions[0]
		
		# Check light requirement
		if cur_interactions.puzzle_requirement == 0 or (cur_interactions.puzzle_requirement == 1 and GameManager.puzzle_1_solved) or (cur_interactions.puzzle_requirement == 2 and GameManager.puzzle_2_solved) or (cur_interactions.puzzle_requirement == 3 and GameManager.puzzle_3_solved):
			# it's lit
			pass
		else:
			# too dark
			DialogueManager.show_dialogue_balloon(load("res://dialogue/interact_dialogues/too_dark.dialogue"), "start")
			return
		
		match cur_interactions.interact_type:
			"print_text": 
				print(cur_interactions.interact_value)
			"pick_up":
				# Emitting self so Teddy can follow
				cur_interactions._emit_pick_up_teddy_signal(self)
				_on_interaction_area_area_exited(cur_interactions)
				has_teddy = true
				DialogueManager.show_dialogue_balloon(load("res://dialogue/picked_up_teddy.dialogue"), "start")
			"door":
				if has_teddy:
					var key = cur_interactions.key
					# Check for keys like so:
					if key == "attic":
						if GameManager.attic_key:
							pass
						else: 
							DialogueManager.show_dialogue_balloon(load("res://dialogue/door_failures/no_attic_key.dialogue"), "start")
							return
					elif key == "cellar":
						if GameManager.cellar_key:
							pass
						else:
							DialogueManager.show_dialogue_balloon(load("res://dialogue/door_failures/no_cellar_key.dialogue"), "start")
							return
					# Once all keys have been checked, enter door
					door.emit(cur_interactions.interact_value)
				else:
					# You gotta get Teddy first!
					DialogueManager.show_dialogue_balloon(load("res://dialogue/door_failures/need_teddy.dialogue"), "start")
			"pop_up":
				cur_interactions._emit_pop_up_signal()
			"puzzle":
				cur_interactions._emit_puzzle_start()
			"item":
				# Pick up a key for example
				var key = cur_interactions.interact_value
				if key == "attic":
					if GameManager.attic_key:
						# key is gone
						pass
					else:
						DialogueManager.show_dialogue_balloon(load("res://dialogue/item_pickups/attic_key.dialogue"), "start")
						GameManager.attic_key = true
				elif key == "cellar":
					if GameManager.cellar_key:
						# key is gone
						pass
					else:
						DialogueManager.show_dialogue_balloon(load("res://dialogue/item_pickups/cellar_key.dialogue"), "start")
						GameManager.cellar_key = true
			"dialogue":
				DialogueManager.show_dialogue_balloon(load(cur_interactions.interact_value), "start")

func _on_timer_timeout() -> void:
	if meter_pause == false:
		player_fear += in_light_index
		fearMeter.value = player_fear
	$Timer.start()
