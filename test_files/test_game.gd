extends Node2D

## Test Game Scene that shows movement between two scenes.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect to the room's door signal
	self.get_child(0).door.connect(_on_room_door)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Signal sent by a room
func _on_room_door(scene_filepath: String) -> void:
	# If the room has finished loading
	if ResourceLoader.load_threaded_get_status(scene_filepath) == 3:
		# Delete the current room and disconnect from it
		var current_room = self.get_child(0)
		self.remove_child(current_room)
		current_room.door.disconnect(_on_room_door)
		current_room.queue_free()
		# Instantiate & add the new room & connect to it
		var new_room = ResourceLoader.load_threaded_get(scene_filepath).instantiate()
		self.add_child(new_room)
		new_room.door.connect(_on_room_door)
	else:
		print("not loaded. loader status: ",ResourceLoader.load_threaded_get_status(scene_filepath))
