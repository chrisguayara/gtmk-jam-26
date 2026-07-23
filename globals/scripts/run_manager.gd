extends Node


var round_number: int = 0
var wallet: int = 0:
	set(value):
		var old_value := wallet
		wallet = maxi(value, 0)
		Signals.wallet_changed.emit(old_value, wallet)

func start_new_run() -> void:
	round_number = 0
	wallet = 0
	EquipmentManager.reset_for_new_run()
	print("[RunManager] New run started")

func advance_round() -> void:
	round_number += 1
