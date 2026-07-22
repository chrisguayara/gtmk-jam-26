extends Node2D
class_name Shop

@onready var grid_container: GridContainer = $CanvasLayer/GridContainer

@onready var wallet: Label = $wallet

func _on_finished_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/kitchen.tscn")

func _ready() -> void:
	wallet.text += " $" + str(Gamemanager.total_money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
