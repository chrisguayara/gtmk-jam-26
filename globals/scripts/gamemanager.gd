extends Node
class_name Game_Manager

var round: int = 0 
var time_limit: float = 40.0
var total_money: float = 1.0
var round_tips: float = 0.0

var customers_per_round = 3
enum game_state {KITCHEN, SHOP}


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
