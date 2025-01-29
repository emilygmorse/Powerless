extends CharacterBody2D


const SPEED = 70.0
var inputs_allowed = true
var teddy_just_picked_up = false
var teddy_picked_up = false

func inputs_enabled() -> void:
	inputs_allowed = true

func inputs_disabled() -> void:
	inputs_allowed = false
	$AnimatedSprite2D.animation = "idle"

func _ready() -> void:
	SignalManager.cutscene_started.connect(inputs_disabled)
	SignalManager.cutscene_ended.connect(inputs_enabled)

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	if inputs_allowed == true:
		
		if teddy_picked_up:
			
			var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
			velocity = direction * SPEED
			$AnimatedSprite2D.play() 

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
			if Input.is_action_just_pressed("interact"):
				_on_teddy_picked_up_interact()
			
		if teddy_just_picked_up:
			teddy_picked_up = true
			teddy_just_picked_up = false
		#if is_hitting_wall:
			#$AnimatedSprite2D.stop()
		
		#position += velocity * delta

#func start(pos):
	#position = pos
	#show()
	#$CollisionShape2D.disabled = false
#
#func _on_body_entered(body: Node2D) -> void:
	#
	#hit.emit()
	#$CollisionShape2D.set_deferred("disabled", true)


#func _on_body_entered(body: Node2D) -> void:
	#is_hitting_wall = true
	#pass # Replace with function body.
#
#
#
#func _on_body_exited(body: Node2D) -> void:
	#is_hitting_wall = false
	#pass # Replace with function body.


func _on_interact_area_pick_up_teddy() -> void:
	teddy_just_picked_up = true
	
func _on_teddy_picked_up_interact():
	teddy_picked_up = false
	teddy_just_picked_up = false
