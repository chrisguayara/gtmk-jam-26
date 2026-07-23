extends Node2D
class_name MainMenu

@export var hunt_button: Button
@export var butcher_button: Button
@export var shop_button: Button

func _ready() -> void:
	hunt_button.pressed.connect(func(): GameManager.request_state(Main.HUNTING))
	butcher_button.pressed.connect(func(): GameManager.request_state(Main.BUTCHERING))
	shop_button.pressed.connect(func(): GameManager.request_state(Main.SHOPPING_CENTER))
