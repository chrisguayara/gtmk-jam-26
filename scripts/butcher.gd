extends Node2D
class_name Butcher


@export var cuts_available: int = 5
const cutting = preload("res://objects/cuttingLine.tscn")
var _cuts_remaining: int = 0


#

func _ready() -> void:
	_cuts_remaining = cuts_available
	Signals.butcher_started.emit()
	print("butcher ready!")
	var cuttingLine = cutting.instantiate()
	add_child(cuttingLine)
	cuttingLine.activate(Vector2(200,200),Vector2(300,300),.5)
	
	

func make_cut() -> void:
	if _cuts_remaining <= 0:
		return
	_cuts_remaining -= 1
	Signals.butcher_cut_made.emit(_cuts_remaining)
	if _cuts_remaining <= 0:
		Signals.butcher_round_complete.emit()
