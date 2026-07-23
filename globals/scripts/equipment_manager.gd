extends Node


var inventory: Dictionary = {} 

func reset_for_new_run() -> void:
	inventory.clear()
	

func get_count(item_id: StringName) -> int:
	return inventory.get(item_id, 0)

func add_item(item_id: StringName, amount: int = 1) -> void:
	inventory[item_id] = get_count(item_id) + amount

func consume_item(item_id: StringName, amount: int = 1) -> bool:
	var current := get_count(item_id)
	if current < amount:
		return false
	inventory[item_id] = current - amount
	return true
