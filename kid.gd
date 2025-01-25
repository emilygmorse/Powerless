extends Area2D

signal hit

@export var speed = 400 
var screen_size
var is_hitting_wall = false
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2.ZERO
	if !is_hitting_wall:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	else: 
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
	
	if velocity.length() > 0 || is_hitting_wall:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0 || is_hitting_wall:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0 || is_hitting_wall:
		$AnimatedSprite2D.animation = "walk"
	
	#if is_hitting_wall:
		#$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)	


#func start(pos):
	#position = pos
	#show()
	#$CollisionShape2D.disabled = false
#
#func _on_body_entered(body: Node2D) -> void:
	#
	#hit.emit()
	#$CollisionShape2D.set_deferred("disabled", true)


func _on_body_entered(body: Node2D) -> void:
	is_hitting_wall = true
	pass # Replace with function body.



func _on_body_exited(body: Node2D) -> void:
	is_hitting_wall = false
	pass # Replace with function body.
