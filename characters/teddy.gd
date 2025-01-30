extends CharacterBody2D

const SPEED = 70.0
const ATTACK_TIME = 3.0
var attack_cool_down = 2.0

var inputs_allowed = true
var attack_avail = true

var teddy_just_picked_up = false
var teddy_picked_up = false

@onready var animation_effect: AnimationPlayer = $TeddyAttackNode/AnimationEffect
@onready var attack_glow: PointLight2D = $TeddyAttackNode/AttackGlow
@onready var attack_area: Area2D = $TeddyAttackNode/AttackGlow/AttackArea
@onready var progress_bar: ProgressBar = $TeddyAttackNode/ProgressBar


func _ready() -> void:
	SignalManager.cutscene_started.connect(inputs_disabled)
	SignalManager.cutscene_ended.connect(inputs_enabled)
	
	attack_area.monitoring = false
	attack_area.monitorable = false
	attack_glow.enabled = false
	
	progress_bar.hide()
	progress_bar.value = 100
	progress_bar.scale = Vector2(1,1)
	progress_bar.get("theme_override_styles/fill").bg_color = Color.CHARTREUSE


func inputs_disabled() -> void:
	inputs_allowed = false
	if teddy_picked_up:
		$AnimatedSprite2D.animation = "idle"

func inputs_enabled() -> void:
	get_tree().create_timer(0.01).timeout.connect(inputs_enabled_timer)

func inputs_enabled_timer() -> void:
	inputs_allowed = true
	if GameManager.teddy_combat_mode:
		progress_bar.show()


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	if inputs_allowed == true:
		
		if teddy_picked_up == true or GameManager.teddy_combat_mode == true:
			
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
			#pickup interaction
			if Input.is_action_just_pressed("interact") and GameManager.teddy_combat_mode == false:
				_on_teddy_picked_up_interact()
		
		#attack interaction
		if GameManager.teddy_combat_mode == true:
			if Input.is_action_just_pressed("interact") and attack_avail == true:
				teddy_attack()
				get_tree().create_timer(ATTACK_TIME).timeout.connect(update_progress_bar)
				progress_bar.value = 0
				progress_bar.get("theme_override_styles/fill").bg_color = Color.CRIMSON
		
		if teddy_just_picked_up:
			teddy_picked_up = true
			teddy_just_picked_up = false
		#if is_hitting_wall:
			#$AnimatedSprite2D.stop()
		
		#position += velocity * delta

func teddy_attack() -> void:
	attack_avail = false
	animation_effect.play("radius_attack")


func update_progress_bar() -> void:
	progress_bar.value += 20
	if progress_bar.value == 100:
		progress_bar.get("theme_override_styles/fill").bg_color = Color.CHARTREUSE
		attack_avail = true
	else:
		get_tree().create_timer(attack_cool_down/5).timeout.connect(update_progress_bar)


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
