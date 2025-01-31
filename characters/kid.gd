extends CharacterBody2D

const SPEED = 70.0
var inputs_allowed = true
var kid

@onready var all_interactions = []
@onready var interact_label = $"Interaction Components/Interact Label"
@onready var hurt_box: Area2D = $HurtBox

signal door(door_info: String)

func _ready() -> void:
	SignalManager.cutscene_started.connect(inputs_disabled)
	SignalManager.cutscene_ended.connect(inputs_enabled)
	$AnimatedSprite2D.play()
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
		
		#move_and_collide(velocity * delta)
		move_and_slide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		execute_interaction()


#Interaction Methods

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
				#pick_up_teddy.emit()
			"door": door.emit(cur_interactions.interact_value)
			"pop_up":
				cur_interactions._emit_pop_up_signal()
