extends CharacterBody2D

class_name Enemy

@export var damage: int = 10
@export var speed_x: float = 25
@export var speed_y: float = 15
@export var shake_time: float = 3
@export var  pos_x_diff: int = 0
@export var  pos_y_diff: int = 0

@export var stretch_time: float = 1.5
@export var scale_diff: float = 0.1
@export var skew_diff = 20

@export var sound_timer := 10.0 #seconds

var player_ref
var enemy_collision: bool = false
var delete_enemy_time: float = 1.5
var direction_x: int = 1
var direction_y: int = 1

var stretch_tween: Tween
var shake_tween: Tween

var init_scale_x: float
var init_scale_y: float
var scale_var_x: float
var scale_var_y: float

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

signal hit_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.destroy_enemies.connect(enemy_destroyed)
	player_ref = get_tree().get_first_node_in_group("Player")
	
	modulate = Color(0.43, 0.43, 0.43, 0.1)
	skew = deg_to_rad(randf_range(-skew_diff, skew_diff))
	init_scale_x = self.scale.x
	init_scale_y = self.scale.y
	scale_var_x = init_scale_x * scale_diff
	scale_var_y = init_scale_y * scale_diff
	stretch()
	shake()
	
	$SoundTimer.start(sound_timer/2.0+randf_range(-sound_timer/4.0,sound_timer/4.0))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if enemy_collision == false:
		horizontal_move()
		vertical_move()
		move_and_slide()

func horizontal_move() -> void:
	if player_ref.global_position.x > self.global_position.x and abs(player_ref.global_position.x - self.global_position.x) > 3:
		sprite_2d.flip_h = false
		direction_x = 1
	elif player_ref.global_position.x < self.global_position.x and abs(player_ref.global_position.x - self.global_position.x) > 3:
		sprite_2d.flip_h = true
		direction_x = -1
	elif abs(player_ref.global_position.x - self.global_position.x) < 3:
		direction_x = 0
	velocity.x = speed_x * direction_x
	
func vertical_move() -> void:
	if player_ref.global_position.y > self.global_position.y:
		direction_y = 1
	else:
		direction_y = -1
	velocity.y = speed_y * direction_y

func shake() -> void:
	var tween = create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(pos_x_diff, pos_y_diff), shake_time)
	get_tree().create_timer(shake_time - .01).timeout.connect(shake_timer)

func shake_timer() -> void:
	if enemy_collision == false:
		pos_x_diff *= -1
		pos_y_diff *= -1
		shake()

func stretch() -> void:
	var tween = create_tween()
	stretch_tween = tween 
	var next_scale_x = randf_range(init_scale_x - scale_var_x, init_scale_x + scale_var_x)
	var next_scale_y = randf_range(init_scale_y - scale_var_y, init_scale_y + scale_var_y)
	var next_modulate = Color(0.43, 0.43, 0.43, randf_range(0.25, 0.6))
	tween.tween_property(self, "scale", Vector2(next_scale_x, next_scale_y), stretch_time)
	tween.parallel().tween_property(self, "skew", deg_to_rad(skew_diff), stretch_time)
	tween.parallel().tween_property(self, "modulate", next_modulate, stretch_time)
	get_tree().create_timer(stretch_time - .01).timeout.connect(stretch_timer)
	
func stretch_timer() -> void:
	if enemy_collision == false:
		stretch_tween.kill()
		skew_diff *= -1
		stretch()

func enemy_destroyed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.01, 0.01), delete_enemy_time)
	tween.parallel().tween_property(self, "modulate", Color(0.43, 0.43, 0.43, 0), delete_enemy_time)
	get_tree().create_timer(delete_enemy_time).timeout.connect(delete_enemy)
	
func enemy_attacks() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(init_scale_x * 2, init_scale_x * 2), delete_enemy_time)
	tween.parallel().tween_property(self, "modulate", Color(0.43, 0.43, 0.43, 0), delete_enemy_time)
	get_tree().create_timer(delete_enemy_time).timeout.connect(delete_enemy)
	SignalManager.hit_player.emit(damage)
	
func delete_enemy() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	enemy_collision = true
	area_2d.set_deferred("monitorable", false)
	area_2d.set_deferred("monitoring", false)
	if stretch_tween:
		stretch_tween.kill()
		stretch_tween = null
	if shake_tween:
		shake_tween.kill()
		shake_tween = null
	
	if area.is_in_group("Player"):
		enemy_attacks()
	if area.is_in_group("Light") or area.is_in_group("Teddy Attack"):
		enemy_destroyed()

#Currently blink functions are not being calledon. Was experimenting with flickering effect did not care for it. May revisit later.
func blink_out() -> void:
	self.hide()
	get_tree().create_timer(0.045).timeout.connect(blink_back)

func blink_back() -> void:
	self.show()
	get_tree().create_timer(randf_range(2.5,4)).timeout.connect(blink_out)


func _on_sound_timer_timeout() -> void:
	$MonsterSound.play()
	$SoundTimer.start(sound_timer+randf_range(-sound_timer/2.0,sound_timer/2.0))
