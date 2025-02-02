extends Control

var start_pos:Vector2
var we_go = false
const SPEED = 10.0

func _ready() -> void:
	start_pos = $VBoxContainer.position

func _process(delta: float) -> void:
	if we_go:
		$VBoxContainer.position += Vector2.UP * SPEED * delta

func _on_button_pressed() -> void:
	self.hide()
	we_go = false
	$VBoxContainer.position = start_pos

func start_credits() -> void:
	we_go = true
