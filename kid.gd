extends CharacterBody2D


const SPEED = 150.0
@onready var all_interactions = []
@onready var interact_label = $"Interaction Components/Interact Label"


func _ready() -> void:
	hide_prompt()
	update_interactions()


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = input_dir * SPEED
	
	#move_and_collide(velocity * delta)
	move_and_slide()
	if Input.is_action_just_pressed("interact"):
		execute_interaction()


func show_prompt() -> void:
	$Prompt.show()

func hide_prompt() -> void:
	$Prompt.hide()
	

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
				cur_interactions._emit_pick_up_teddy_signal()
				_on_interaction_area_area_exited(cur_interactions)
				#pick_up_teddy.emit()
