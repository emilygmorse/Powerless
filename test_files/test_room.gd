extends Node2D

@onready var popup = $DrawerPopUp

# Each door can have a target scene it goes to
var door_path := "res://test_files/test_room_2.tscn"
signal door(scene_filepath: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(door_path)
	popup.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Called when E is pressed near door
func _on_door_door_used() -> void:
	door.emit(door_path)



#func _on_window_close_requested() -> void:
	#popup.hide() # Replace with function body.


func _on_button_pressed() -> void:
	popup.hide()
 

func _on_interact_with_drawers_pop_up() -> void:
	popup.show()
