extends ROOM

@onready var light_source_circle: PointLight2D = $LightSourceCircle
@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var enemy_spawner_2: Node2D = $EnemySpawner2
@onready var enemy_spawner_3: Node2D = $EnemySpawner3
@onready var power_out: AudioStreamPlayer2D = $PowerOut

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.bedroom_intro == false:
		room_light_status(true)
		get_tree().create_timer(0.1).timeout.connect(set_intro)
	elif GameManager.puzzle_2_solved and GameManager.puzzle_3_solved == false:
		light_source_circle.queue_free()
		room_light_status(false)
		enemy_spawner.spawn_enemy()
		enemy_spawner_2.spawn_enemy()
		enemy_spawner_3.spawn_enemy()
	elif GameManager.puzzle_3_solved:
		room_light_status(true)
		###TRIGGER FINAL DIALOGUE / CUTSCENE ###
		DialogueManager.show_dialogue_balloon(load("res://dialogue/final_bedroom.dialogue"), "start")
	elif GameManager.bedroom_intro == true:
		# function in room_base.gd
		room_light_status(false)
		

func intro_dialogue() -> void:
	create_dialogue_balloon()
	DialogueManager.show_dialogue_balloon(load("res://dialogue/intro_bedroom.dialogue"), "start")

func set_intro() -> void:
	SignalManager.cutscene_started.emit()
	get_tree().create_timer(1.5).timeout.connect(power_outage)
	get_tree().create_timer(2.5).timeout.connect(intro_dialogue)

func power_outage() -> void:
	power_out.play()
	room_light_status(false)
