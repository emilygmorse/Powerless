extends Node2D

## The purpose of this Scene is to actually play the game.
# It should load rooms and transition between them,
# bringing along the player and teddy.

## There should be a starting room scene as the first child node of this scene.

enum TRANSITION_STATE { NONE, IN, OUT }
var transition := TRANSITION_STATE.NONE
const TRANSITION_SPEED := 0.2 # between 0 and 1

var current_room
var new_room
var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set current room
	current_room = self.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	## Scene Transition
	if transition == TRANSITION_STATE.NONE:
		pass
	elif transition == TRANSITION_STATE.OUT:
		# fade to black
		self.set_modulate(lerp(self.get_modulate(), Color(0,0,0,1), TRANSITION_SPEED))
		if self.get_modulate().is_equal_approx(Color(0,0,0,1)):
			# Delete the current room
			self.remove_child(current_room)
			current_room.queue_free()
			# add the new room & update current room
			self.add_child(new_room)
			current_room = new_room
			# Update Kid Position
			$Kid.position = target_position
			# Transition back in
			transition = TRANSITION_STATE.IN
	elif transition == TRANSITION_STATE.IN:
		# fade back in
		self.set_modulate(lerp(self.get_modulate(), Color(1,1,1,1), TRANSITION_SPEED))
		if self.get_modulate().is_equal_approx(Color(1,1,1,1)):
			transition = TRANSITION_STATE.NONE
	else:
		assert(false)


## When kid uses door 
func _on_kid_opens_door(door_info: String) -> void:
	# split door info up into its components
	var args = door_info.split(",")
	var scene_filepath = args[0]
	target_position = Vector2(float(args[1]),float(args[2]))
	
	if not scene_filepath:
		push_error("No Scene Filepath from door")
	else:
		var load_status = ResourceLoader.load_threaded_get_status(scene_filepath)
		# If the room has finished loading
		if load_status == 3:
			# Set up transition from current room to new room
			# current_room should already be correct
			new_room = ResourceLoader.load_threaded_get(scene_filepath).instantiate()
			# Begin scene transition
			transition = TRANSITION_STATE.OUT
		else:
			print("not loaded. loader status: ",load_status)
			#TODO: Implement a loading screen here instead if necessary
