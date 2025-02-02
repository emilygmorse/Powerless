extends Node

signal dialogue_ended()
signal cutscene_started()
signal cutscene_ended()
signal mid_dialogue()

# Activate when kid is in or out of light ? -Andrew
signal light_check(status: bool)

# Spawn an enemy & continue spawning
signal activate_enemy_spawner()

signal hit_player(damage: int)
signal puzzle_mode()
signal puzzle_solved()
signal destroy_enemies()


signal breaker_switches_set()
signal wires_shorted()

signal instr_toggle(display: bool)
signal breaker_box_toggle(display: bool)
signal wire_puzzle_toggle(display: bool)

## Signals for music and sound triggers
signal outside(yes: bool)
signal ambient_music(yes: bool)
signal theme_music(yes: bool)
