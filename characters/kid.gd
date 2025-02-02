extends CharacterBody2D

const SPEED = 70.0
var inputs_allowed = true
var has_teddy = false

@onready var all_interactions = []
@onready var interact_label = $"Interaction Components/Interact Label"
@onready var hurt_box: Area2D = $HurtBox
@onready var fear_meter = $"../FearMeter"
#@onready var current_room: ROOM = find_room(self.get_parent, ROOM)
@export var player_fear: int = 0
@export var in_light_index = 0

signal door(door_info: String)

func _ready() -> void:
	SignalManager.cutscene_started.connect(inputs_disabled)
	SignalManager.cutscene_ended.connect(inputs_enabled)
	SignalManager.light_check.connect(light_check)
	$AnimatedSprite2D.play()
	SignalManager.hit_player.connect(update_fear)
	SignalManager.max_fear_reached.connect(return_to_checkpoint)
	update_interactions()

func inputs_disabled() -> void:
	inputs_allowed = false
	$AnimatedSprite2D.animation = "idle"

func inputs_enabled() -> void:
	get_tree().create_timer(0.01).timeout.connect(inputs_enabled_timer)

func inputs_enabled_timer() -> void:
	inputs_allowed = true


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement
	if inputs_allowed == true and GameManager.teddy_combat_mode == false:
		
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
	print("Fear meter value before decrease {}", fear_meter.value)
	fear_meter.value = player_fear
	print("Fear meter value after decrease {}", fear_meter.value)
	

func light_check(standing_in_light : bool):	
	if standing_in_light:
		in_light_index = -5
	else:
		in_light_index = 1
		

func return_to_checkpoint():
	player_fear = 0
	fear_meter.value = 0
	door.emit("res://rooms/bedroom.tscn,280,115")
	

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
		match cur_interactions.interact_type:
			"print_text": 
				print(cur_interactions.interact_value)
			"pick_up":
				#print(cur_interactions.interact_value)
				# Emitting self so Teddy can follow
				cur_interactions._emit_pick_up_teddy_signal(self)
				_on_interaction_area_area_exited(cur_interactions)
				has_teddy = true
				DialogueManager.show_dialogue_balloon(load("res://dialogue/picked_up_teddy.dialogue"), "start")
			"door":
				if has_teddy:
					door.emit(cur_interactions.interact_value)
				else:
					DialogueManager.show_dialogue_balloon(load("res://dialogue/need_teddy.dialogue"), "start")
			"pop_up":
				cur_interactions._emit_pop_up_signal()
			"puzzle":
				cur_interactions._emit_puzzle_start()

func _on_timer_timeout() -> void:
	player_fear += in_light_index
	fear_meter.value = player_fear
	$LightTimer.start()
