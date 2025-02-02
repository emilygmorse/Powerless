extends Node

var wire_puzzle_solved_1: bool = false
var wire_puzzle_solved_2: bool = false
var wire_puzzle_solved_3: bool = false

var breaker_tripped_1: bool = false
var breaker_tripped_2: bool = false
var breaker_tripped_3: bool = false

#Scenes
var bedroom_intro = false
var living_room_intro = false
var kitchen_intro = false
var kitchen_mid = false
var puzzle_intro = false
var basement_intro = false
var final_pep_talk = true

#Keys
var puzzle_1_solved = false
var puzzle_2_solved = false
var puzzle_3_solved = false

var cellar_key = false
var attic_key = false

func reset_game() -> void:
	wire_puzzle_solved_1 = false
	wire_puzzle_solved_2 = false
	wire_puzzle_solved_3 = false

	breaker_tripped_1 = false
	breaker_tripped_2 = false
	breaker_tripped_3 = false

	#Scenes
	bedroom_intro = false
	living_room_intro = false
	kitchen_intro = false
	kitchen_mid = false
	puzzle_intro = false

	#Keys
	puzzle_1_solved = false
	puzzle_2_solved = false
	puzzle_3_solved = false
	attic_key = false
	cellar_key = false
