extends Node2D
class_name ShoppingCenter


const BUTCHER_SHOP_ID: StringName = &"butcher_shop"
const LURETRAP_SHOP_ID: StringName = &"luretrap_shop"
const WEAPON_SHOP_ID: StringName = &"weapon_shop"

@onready var butcher_shop: Sprite2D = $butcher_shop
@onready var luretrap_shop: Sprite2D = $luretrap_shop
@onready var weapon_shop: Sprite2D = $weapon_shop
@onready var hunt_sign: Sprite2D = $hunt_sign

@onready var butcher_hover: Area2D = $butcher_hover
@onready var luretrap_hover: Area2D = $luretrap_hover
@onready var weapon_hover: Area2D = $weapon_hover
@onready var hunt_hover: Area2D = $hunt_hover

func _ready() -> void:
	butcher_shop.visible = false
	weapon_shop.visible = false
	luretrap_shop.visible = false
	hunt_sign.visible = false

	_wire_door(butcher_hover, butcher_shop, func(): Signals.shop_entered.emit(BUTCHER_SHOP_ID) )
	_wire_door(luretrap_hover, luretrap_shop, func(): Signals.shop_entered.emit(LURETRAP_SHOP_ID))
	_wire_door(weapon_hover, weapon_shop, func(): Signals.shop_entered.emit(WEAPON_SHOP_ID))
	_wire_door(hunt_hover, hunt_sign, func(): GameManager.request_state(Main.HUNTING))

func _wire_door(area: Area2D, sign_sprite: Sprite2D, on_click: Callable) -> void:
	area.mouse_entered.connect(func(): sign_sprite.visible = true)
	area.mouse_exited.connect(func(): sign_sprite.visible = false)
	area.input_event.connect(func(_viewport, event, _shape_idx):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			on_click.call()
	)
