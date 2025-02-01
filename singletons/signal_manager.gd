extends Node

signal dialogue_ended()
signal cutscene_started()
signal cutscene_ended()
signal mid_dialogue()

signal light_check(status: bool)
signal activate_enemy_spawner()
signal puzzle_mode()

signal breaker_switches_set()
signal wires_shorted()

signal instr_toggle(display: bool)
signal breaker_box_toggle(display: bool)
signal wire_puzzle_toggle(display: bool)
