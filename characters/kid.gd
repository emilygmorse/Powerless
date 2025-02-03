extends CharacterBody2D

const SPEED = 70.0
var inputs_allowed = true
var has_teddy = false
var puzzle_mode = false
var meter_pause = false
var end = false
var bed_pos = Vector2(75,100)

@onready var all_interactions = []
@onready var interact_label = $"Interaction Components/Interact Label"
@onready var hurt_box: Area2D = $HurtBox
@onready var fear_meter = $"../FearMeter"
@onready var show_reset_dialogue = true
#@onready var current_room: ROOM = find_room(self.get_parent, ROOM)
@export var player_fear: int = 0
@export var in_light_index = 0

# Signals that kid has gone through a door
signal door(door_info: String)

func _ready() -> void:
	SignalManager.cutscene_started.connect(cutscene_started)
	SignalManager.cutscene_ended.connect(cutscene_ended)
	SignalManager.light_check.connect(light_check)
	SignalManager.puzzle_mode.connect(puzzle_mode_timer)
	SignalManager.puzzle_solved.connect(puzzle_solved)
	SignalManager.end_game.connect(game_end)

	$AnimatedSprite2D.play()
	SignalManager.hit_player.connect(update_fear)
	SignalManager.max_fear_reached.connect(return_to_checkpoint)
	update_interactions()
	
	# This should make 2D sounds positional to Kid
	$AudioListener2D.make_current()

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

func game_end() -> void:
	end = true
	$AnimatedSprite2D.animation = "walk_left"

func _physics_process(_delta: float) -> void:
	
	if end == true:
		#End game cutscene logic
		var dir = bed_pos - self.position
		if dir.length() < 10:
			SignalManager.credits.emit()
		else:
			velocity = dir.normalized() * SPEED / 2.0
			move_and_slide()
			
	
	# Get the input direction and handle the movement
	elif inputs_allowed == true:
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
	player_fear += damage
	fear_meter.value = player_fear
	

func light_check(standing_in_light : bool):	
	if standing_in_light:
		in_light_index = -15
	else:
		in_light_index = 1
		

func return_to_checkpoint():
	player_fear = 0
	fear_meter.value = 0
	#if we reset during a puzzle, we have to call this to give control back to kid
	if puzzle_mode:
		puzzle_solved()
		SignalManager.fear_reset_during_puzzle.emit()
	door.emit(GameManager.checkpoint_dict.get(GameManager.current_checkpoint))
	if show_reset_dialogue:
		show_reset_dialogue = false
		DialogueManager.show_dialogue_balloon(load("res://dialogue/first_checkpoint_reset.dialogue"), "start")
	

#puzzle methods

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
							GameManager.current_checkpoint = 2
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
		if player_fear <= 0:
			player_fear = 0
			fear_meter.value = 0
		else:
			fear_meter.value = player_fear
	$LightTimer.start()
