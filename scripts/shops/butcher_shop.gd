extends Node2D
class_name ButcherShop


const ITEM_COSTS: Dictionary = {
	&"stone_knife": 0,
	&"handle_knife": 10,
	&"obsidian_knife": 25,
}
@onready var _hover_areas: Dictionary = {
	&"stone_knife": $stone_hover,
	&"handle_knife": $handle_hover,
	&"obsidian_knife": $obsidian_hover,
	
}
@onready var _sprites: Dictionary = {
	&"stone_knife": $stone_knife,
	&"handle_knife" : $handle_knife,
	&"obsidian_knife":$obsidian_knife
}
# Called when the node enters the scene tree for the first time.
@onready var wallet_label: Label = $wallet
@onready var price_label: Label = $PriceLabel

func _ready() -> void:
	wallet_label.text = str(RunManager.wallet)
	price_label.visible = false
	Signals.wallet_changed.connect(_on_wallet_changed)

	for item_id in _hover_areas.keys():
		_sprites[item_id].visible = false
		var area: Area2D = _hover_areas[item_id]
		area.mouse_entered.connect(_on_item_hover.bind(item_id))
		area.mouse_exited.connect(_on_item_unhover.bind(item_id))
		area.input_event.connect(_on_item_input.bind(item_id))

func _on_item_hover(item_id: StringName) -> void:
	_sprites[item_id].visible = true
	var cost: int = ITEM_COSTS[item_id]
	price_label.text = "Free" if cost == 0 else str(cost)
	price_label.global_position = _sprites[item_id].global_position + Vector2(0, -40)
	price_label.visible = true

func _on_item_unhover(item_id: StringName) -> void:
	_sprites[item_id].visible = false
	price_label.visible = false

func _on_item_input(_viewport, event: InputEvent, _shape_idx, item_id: StringName) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_buy(item_id, ITEM_COSTS[item_id])

func _buy(item_id: StringName, cost: int) -> void:
	if RunManager.wallet < cost:
		return
	RunManager.wallet -= cost
	EquipmentManager.add_item(item_id)
	Signals.item_purchased.emit(item_id, cost)
	print("You have purchased "+  item_id)

func _on_wallet_changed(_old: int, new_amount: int) -> void:
	wallet_label.text = str(new_amount)


func _on_leave_pressed() -> void:
	Signals.shop_exited.emit()
