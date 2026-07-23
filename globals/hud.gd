extends CanvasLayer
class_name HUD


@export var wallet_label: Label
@export var context_label: Label  

func _ready() -> void:
	Signals.wallet_changed.connect(_on_wallet_changed)
	Signals.hunt_beast_caught.connect(func(_beast): _set_context("Beast Caught"))
	Signals.hunt_resource_depleted.connect(func(): _set_context("Out of spears"))
	Signals.butcher_cut_made.connect(func(cuts_remaining): _set_context("%d cuts left" % cuts_remaining))

	wallet_label.text = str(RunManager.wallet)
	context_label.text = ""

func _on_wallet_changed(_old: int, new_amount: int) -> void:
	wallet_label.text = str(new_amount)

func _set_context(text: String) -> void:
	context_label.text = text
