extends Node2D
class_name MainMenu


@export var shop_button: Button

func _ready() -> void:
	shop_button.pressed.connect(func(): GameManager.request_state(Main.SHOPPING_CENTER))
