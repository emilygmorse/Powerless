extends CharacterBody2D

const SPEED = 70.0
const ATTACK_TIME = 3.0
const FOLLOW_DISTANCE = 17.0
var attack_cool_down = 2.0

var inputs_allowed = true
var attack_avail = true
var kid

enum TEDDY_MODE { SIT, FOLLOW, FIGHT, PAUSE }
var current_mode := TEDDY_MODE.SIT

var teddy_just_picked_up = false
var teddy_picked_up = false

@onready var animation_effect: AnimationPlayer = $TeddyAttackNode/AnimationEffect
@onready var attack_glow: PointLight2D = $TeddyAttackNode/AttackGlow
@onready var attack_area: Area2D = $TeddyAttackNode/AttackGlow/AttackArea
@onready var progress_bar: ProgressBar = $TeddyAttackNode/ProgressBar


func _ready() -> void:
	SignalManager.cutscene_started.connect(inputs_disabled)
	SignalManager.cutscene_ended.connect(inputs_enabled)
	SignalManager.puzzle_mode.connect(teddy_fight_mode_activate)
	SignalManager.puzzle_solved.connect(puzzle_solved)

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


func teddy_fight_mode_activate() -> void:
	inputs_enabled()
	progress_bar.show()
	teddy_picked_up = false
	self.current_mode = TEDDY_MODE.FIGHT

func puzzle_solved() -> void:
	inputs_disabled()
	progress_bar.hide()
	self.current_mode = TEDDY_MODE.FOLLOW


	
func _physics_process(delta: float) -> void:
	
	if self.current_mode == TEDDY_MODE.FOLLOW:
		var direction:Vector2 = (kid.position - self.position)
		
		if direction.length() < FOLLOW_DISTANCE:
			velocity = Vector2(0,0)
		elif direction.length() < FOLLOW_DISTANCE * 2.0:
			velocity = direction.normalized() * SPEED * 0.75
		else:
			velocity = direction.normalized() * SPEED
			
		
		$AnimatedSprite2D.play() 
	
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "walk_left"
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "walk_right"
		#TEST: Commented for now. Follow animations still looks pretty good with just left and right walk. Stretch goal to get up and down integrated
		#elif velocity.y > 0:
			#$AnimatedSprite2D.animation = "walk_down"
		#elif velocity.y < 0: 
			#$AnimatedSprite2D.animation = "walk_up"
		elif (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") 
		or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
			return
		else:
			get_tree().create_timer(0.1).timeout.connect(go_idle)
		
		
		move_and_slide()
		
	elif self.current_mode == TEDDY_MODE.FIGHT:
		# If fighting shadows?
		# Get the input direction and handle the movement/deceleration.
		if inputs_allowed == true:
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
				#if Input.is_action_just_pressed("interact") and GameManager.teddy_combat_mode == false:
					#_on_teddy_picked_up_interact()
			
			#attack interaction
			if Input.is_action_just_pressed("interact") and attack_avail == true:
				teddy_attack()
				get_tree().create_timer(ATTACK_TIME).timeout.connect(update_progress_bar)
				progress_bar.value = 0
				progress_bar.get("theme_override_styles/fill").bg_color = Color.CRIMSON
			
			
			#if is_hitting_wall:
				#$AnimatedSprite2D.stop()
			
			#position += velocity * delta
	elif self.current_mode == TEDDY_MODE.SIT:
		# At the beginning of the game
		pass
	elif self.current_mode == TEDDY_MODE.PAUSE:
		# When kid is actively doing puzzle
		pass
	else:
		assert(false)
	
	if teddy_just_picked_up:
		teddy_picked_up = true
		teddy_just_picked_up = false
		$AnimatedSprite2D.animation = "idle"



func teddy_attack() -> void:
	attack_avail = false
	animation_effect.play("radius_attack")

func go_idle() -> void:
	if (Input.is_action_pressed("move_left") == false or Input.is_action_pressed("move_right") == false 
	or Input.is_action_pressed("move_up") == false or Input.is_action_pressed("move_down") == false):
		$AnimatedSprite2D.animation = "idle"

func update_progress_bar() -> void:
	progress_bar.value += 20
	if progress_bar.value == 100:
		progress_bar.get("theme_override_styles/fill").bg_color = Color.CHARTREUSE
		attack_avail = true
	else:
		get_tree().create_timer(attack_cool_down/5).timeout.connect(update_progress_bar)


# When interacted with
func _on_interact_area_pick_up_teddy(kid_node) -> void:
	teddy_just_picked_up = true
	# Get kid from pickup signal so Teddy can follow
	self.kid = kid_node
	self.current_mode = TEDDY_MODE.FOLLOW
	# Disable interaction with teddy; should only need to pick up Teddy once
	$InteractArea.set_monitorable(false) 


# I don't think this is necessary -Andrew
#func _on_teddy_picked_up_interact():
	#teddy_picked_up = false
	#teddy_just_picked_up = false
