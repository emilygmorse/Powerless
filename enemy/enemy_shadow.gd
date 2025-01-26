extends CharacterBody2D

class_name Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D

var stretch_tween: Tween
var stretch_tween_time: float = 3.0

var shake_tween: Tween
var shake_tween_time: float = 0.03

var init_scale_x: float #= self.scale.x
var init_scale_y: float #= self.scale.y
var scale_var_x: float #= init_scale_x/5
var scale_var_y: float #= init_scale_y/5

var current_scale_x: float = init_scale_x
var current_scale_y: float = init_scale_y
var current_skew: float = 0
var current_modulate

var current_pos_x: int = 0
var current_pos_y: int = 0
var current_rotation: float = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate = Color(100, 100, 100, 0.75)
	init_scale_x = self.scale.x
	init_scale_y = self.scale.y
	scale_var_x = init_scale_x/5
	scale_var_y = init_scale_y/5
	
	stretch()
	shake()
	blink_back()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shake() -> void:
	var tween = create_tween()
	current_rotation = randf_range(deg_to_rad(-5), deg_to_rad(5))
	current_pos_x = randi_range(-3, 3)
	current_pos_y = randi_range(-3, 3)
	#tween.tween_property(self, "rotation", current_rotation, shake_tween_time)
	tween.parallel().tween_property(sprite_2d, "position", Vector2(current_pos_x, current_pos_y), shake_tween_time)
	get_tree().create_timer(shake_tween_time - .01).timeout.connect(shake_timer)

func shake_timer() -> void:
	#self.rotation = current_rotation
	sprite_2d.position = Vector2(current_pos_x, current_pos_y)
	shake()

func stretch() -> void:
	var tween = create_tween()
	stretch_tween = tween 
	current_scale_x = randf_range(init_scale_x - scale_var_x, init_scale_x + scale_var_x)
	current_scale_y = randf_range(init_scale_y - scale_var_y, init_scale_y + scale_var_y)
	current_skew = randf_range(deg_to_rad(-15), deg_to_rad(15))
	current_modulate = Color(100, 100, 100, randf_range(0.5, 0.75))
	tween.tween_property(self, "scale", Vector2(current_scale_x,current_scale_y), stretch_tween_time)
	tween.parallel().tween_property(self, "skew", current_skew, stretch_tween_time)
	tween.parallel().tween_property(sprite_2d, "modulate", current_modulate, stretch_tween_time)
	get_tree().create_timer(stretch_tween_time - .01).timeout.connect(stretch_timer)
	print(init_scale_x)
	print(scale_var_x)
	print(current_scale_x)
	
func stretch_timer() -> void:
	stretch_tween.kill()
	self.scale = Vector2(current_scale_x, current_scale_y)
	self.skew = current_skew
	sprite_2d.modulate = current_modulate
	stretch()
	
func blink_out() -> void:
	self.hide()
	get_tree().create_timer(0.045).timeout.connect(blink_back)

func blink_back() -> void:
	self.show()
	var flip = randi_range(0, 1)
	sprite_2d.flip_h = flip
	get_tree().create_timer(randf_range(2.5,4)).timeout.connect(blink_out)
