extends Area2D

@export var interact_label = "none"
@export var connecting_room_path: String
@export var target_coords: Vector2

var interact_type = "door"
var interact_value: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the interact value so it is picked up by the Kid
	interact_value = ",".join([connecting_room_path,str(target_coords.x),str(target_coords.y)])
	# Background load the scene this door points to.
	ResourceLoader.load_threaded_request(connecting_room_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
