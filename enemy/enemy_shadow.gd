extends CharacterBody2D

class_name Enemy

@export var speed: float = 50
@export var shake_time: float = 3
@export var  pos_x_diff: int = 0
@export var  pos_y_diff: int = 50

@export var stretch_time: float = 1.5
@export var scale_diff: float = 0.1
@export var skew_diff = 20

var player_ref
var direction_x: int = 1
var direction_y: int = 1

var stretch_tween: Tween
var shake_tween: Tween

var init_scale_x: float
var init_scale_y: float
var scale_var_x: float
var scale_var_y: float

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	
	modulate = Color(100, 100, 100, 0.1)
	init_scale_x = self.scale.x
	init_scale_y = self.scale.y
	scale_var_x = init_scale_x * scale_diff
	scale_var_y = init_scale_y * scale_diff
	stretch()
	shake()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	horizontal_move()
	vertical_move()
	move_and_slide()

func horizontal_move() -> void:
	if player_ref.global_position.x > self.global_position.x and abs(player_ref.global_position.x - self.global_position.x) > 10:
		sprite_2d.flip_h = false
		direction_x = 1
	elif player_ref.global_position.x < self.global_position.x and abs(player_ref.global_position.x - self.global_position.x) > 10:
		sprite_2d.flip_h = true
		direction_x = -1
	elif abs(player_ref.global_position.x - self.global_position.x) < 10:
		direction_x = 0
	velocity.x = speed * direction_x
	
func vertical_move() -> void:
	if player_ref.global_position.y > self.global_position.y:
		direction_y = 1
	else:
		direction_y = -1
	velocity.y = speed * direction_y

func shake() -> void:
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(pos_x_diff, pos_y_diff), shake_time)
	get_tree().create_timer(shake_time - .01).timeout.connect(shake_timer)

func shake_timer() -> void:
	pos_x_diff *= -1
	pos_y_diff *= -1
	shake()

func stretch() -> void:
	var tween = create_tween()
	stretch_tween = tween 
	var next_scale_x = randf_range(init_scale_x - scale_var_x, init_scale_x + scale_var_x)
	var next_scale_y = randf_range(init_scale_y - scale_var_y, init_scale_y + scale_var_y)
	var next_modulate = Color(100, 100, 100, randf_range(0.25, 0.75))
	tween.tween_property(self, "scale", Vector2(next_scale_x, next_scale_y), stretch_time)
	tween.parallel().tween_property(self, "skew", deg_to_rad(skew_diff), stretch_time)
	tween.parallel().tween_property(self, "modulate", next_modulate, stretch_time)
	get_tree().create_timer(stretch_time - .01).timeout.connect(stretch_timer)
	
func stretch_timer() -> void:
	stretch_tween.kill()
	skew_diff *= -1
	stretch()

#Currently blink functions are not being calledon. Was experimenting with flickering effect did not care for it. May revisit later.
func blink_out() -> void:
	self.hide()
	get_tree().create_timer(0.045).timeout.connect(blink_back)

func blink_back() -> void:
	self.show()
	get_tree().create_timer(randf_range(2.5,4)).timeout.connect(blink_out)
