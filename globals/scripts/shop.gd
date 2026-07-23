extends Node2D
class_name Shop


enum Mode { BUY, SELL }

@export var shop_id: StringName
@export var mode: Mode = Mode.BUY

@onready var grid_container: GridContainer = $CanvasLayer/GridContainer
@onready var wallet_label: Label = $wallet

func _ready() -> void:
	wallet_label.text = str(RunManager.wallet)
	Signals.wallet_changed.connect(_on_wallet_changed)
	_populate_catalog()

func _populate_catalog() -> void:
	var items: Array = ShopCatalog.get_catalog(shop_id)
	

func _buy(item_id: StringName, cost: int) -> void:
	if RunManager.wallet < cost:
		return
	RunManager.wallet -= cost
	EquipmentManager.add_item(item_id)
	Signals.item_purchased.emit(item_id, cost)

func _sell(item_id: StringName, value: int) -> void:
	if not EquipmentManager.consume_item(item_id):
		return
	RunManager.wallet += value
	Signals.item_sold.emit(item_id, value)

func _on_wallet_changed(_old: int, new_amount: int) -> void:
	wallet_label.text = str(new_amount)

func _on_finished_pressed() -> void:
	Signals.shop_exited.emit()
