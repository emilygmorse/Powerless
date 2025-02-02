extends Node2D

## The purpose of this Scene is to actually play the game.
# It should load rooms and transition between them,
# bringing along the player and teddy.

## There should be a starting room scene as the first child node of this scene.
# Currently Bedroom

enum TRANSITION_STATE { NONE, IN, OUT }
var transition := TRANSITION_STATE.NONE
const TRANSITION_SPEED := 0.2 # between 0 and 1

var current_room: Node
var new_room_resource: Resource
var new_room: Node
var target_position: Vector2
var room_path: String
var checkpoint_path: String
var checkpoint_pos: Vector2

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
			new_room = new_room_resource.instantiate()
			self.add_child(new_room)
			current_room = new_room
			#print(current_room.get_name())
			# Update Kid & Teddy Position
			$Kid.position = target_position
			$Teddy.position = target_position + Vector2.UP*2
			# Reset checkpoint load just in case
			if checkpoint_path:
				ResourceLoader.load_threaded_request(checkpoint_path)
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
	var path = args[0]
	var pos := Vector2(float(args[1]),float(args[2]))
	
	if not path:
		push_error("No Scene Filepath from door")
	else:
		load_room(path,pos)

func load_room(path, pos) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(path)
	# If the room has finished loading
	if load_status == 3:
		# Set up transition from current room to new room
		new_room_resource = ResourceLoader.load_threaded_get(path)
		room_path = path
		target_position = pos
		# Begin scene transition
		transition = TRANSITION_STATE.OUT
	else:
		print("not loaded. loader status: ",load_status)
		#TODO: Implement a loading screen here instead if necessary


# These might be unnecessary, see MorseCode
# On second thought, these might be necessary
func set_checkpoint() -> void:
	checkpoint_path = room_path
	checkpoint_pos = target_position
	ResourceLoader.load_threaded_request(checkpoint_path)

func goto_checkpoint() -> void:
	load_room(checkpoint_path,checkpoint_pos)
