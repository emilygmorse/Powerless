extends Node2D

@onready var popup = $DrawerPopUp


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#func _on_window_close_requested() -> void:
	#popup.hide() # Replace with function body.


func _on_button_pressed() -> void:
	popup.hide()
 

func _on_interact_with_drawers_pop_up() -> void:
	popup.show()
