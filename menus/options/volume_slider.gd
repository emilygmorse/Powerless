extends HSlider

@onready var _bus := AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.value = db_to_linear(AudioServer.get_bus_volume_db(_bus))


func _on_value_changed(v:float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(v))
