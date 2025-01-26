extends Area2D

signal door_used
var near_door := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_prompt()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_prompt() -> void:
	$Prompt.show()

func hide_prompt() -> void:
	$Prompt.hide()


func _on_body_entered(_body: Node2D) -> void:
	show_prompt()
	near_door = true


func _on_body_exited(_body: Node2D) -> void:
	hide_prompt()
	near_door = false

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and near_door:
		#print("door used")
		door_used.emit()
