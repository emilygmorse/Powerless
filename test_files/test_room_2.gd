extends Node2D

# Each door can have a target scene it goes to
var door_path := "res://test_files/test_room.tscn"
signal door(scene_filepath: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(door_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_door_door_used() -> void:
	door.emit(door_path)
