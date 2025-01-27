extends Node2D

# The purpose of this Scene is to actually play the game.
# It should load rooms and transition between them,
# bringing along the player and teddy.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# When kid uses door 
func _on_kid_opens_door(door_info: String) -> void:
	# split door info up into its components
	var args = door_info.split(",")
	var scene_filepath = args[0]
	var target_position = Vector2(float(args[1]),float(args[2]))
	
	if not scene_filepath:
		push_error("No Scene Filepath from door")
	else:
		# If the room has finished loading
		if ResourceLoader.load_threaded_get_status(scene_filepath) == 3:
			# Delete the current room and disconnect from it
			var current_room = self.get_child(-1) # Make sure the starting room is always the bottom node
			self.remove_child(current_room)
			current_room.queue_free()
			# Instantiate & add the new room & connect to it
			var new_room = ResourceLoader.load_threaded_get(scene_filepath).instantiate()
			self.add_child(new_room)
			# Update Kid Position
			$Kid.position = target_position
		else:
			print("not loaded. loader status: ",ResourceLoader.load_threaded_get_status(scene_filepath))
			#TODO: Implement a loading screen here instead if necessary
