extends Node2D
class_name LureTrapShop


const ITEM_COSTS: Dictionary = {
	&"rocks": 0,
	&"spear": 20,
	&"bow": 35,
	&"axe": 25,
	&"sling": 10,
}

@onready var wallet_label: Label = $wallet
@onready var price_label: Label = $PriceLabel  

@onready var _sprites: Dictionary = {
	#&"rocks": $rocks
}

@onready var _hover_areas: Dictionary = {
	#&"rocks": $rock_hover

}

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

func _on_finished_pressed() -> void:
	Signals.shop_exited.emit()
