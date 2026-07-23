extends Node2D
class_name ShoppingCenter

@onready var butcher_shop: Sprite2D = $butcher_shop
@onready var luretrap_shop: Sprite2D = $luretrap_shop
@onready var weapon_shop: Sprite2D = $weapon_shop
@onready var hunt_sign: Sprite2D = $hunt_sign

func _on_shop_door_pressed(shop_id: StringName) -> void:
	Signals.shop_entered.emit(shop_id)

func _ready() -> void:
	butcher_shop.visible = false
	weapon_shop.visible = false
	luretrap_shop.visible = false
	hunt_sign.visible = false

func _on_butcher_mouse_entered() -> void:
	butcher_shop.visible = true


func _on_butcher_mouse_exited() -> void:
	butcher_shop.visible = false


func _on_luretrap_mouse_entered() -> void:
	luretrap_shop.visible = true


func _on_luretrap_mouse_exited() -> void:
	luretrap_shop.visible = false


func _on_weapon_mouse_entered() -> void:
	weapon_shop.visible = true


func _on_weapon_mouse_exited() -> void:
	weapon_shop.visible = false


func _on_hunt_mouse_entered() -> void:
	hunt_sign.visible = true


func _on_hunt_mouse_exited() -> void:
	hunt_sign.visible = false
