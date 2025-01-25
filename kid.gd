extends CharacterBody2D


const SPEED = 150.0


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	
	velocity = Vector2(x_direction,y_direction).normalized() * SPEED
	
	#move_and_collide(velocity * delta)
	move_and_slide()
