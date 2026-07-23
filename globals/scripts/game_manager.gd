extends Node


var main: Main:
	get:
		if main == null and get_tree().current_scene is Main:
			main = get_tree().current_scene
		return main

var player: Node:
	get:
		if player == null and main:
			player = main.get_node_or_null("Player")
		return player

var hud: Node:
	get:
		if hud == null and main:
			hud = main.hud
		return hud

func request_state(state_name: StringName, args = null) -> void:
	if main:
		print("changed to " + state_name)
		main.game_state_machine.change_states(state_name, args)
