extends Node2D
class_name ShoppingCenter

func _on_shop_door_pressed(shop_id: StringName) -> void:
	Signals.shop_entered.emit(shop_id)
