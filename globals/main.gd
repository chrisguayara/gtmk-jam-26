extends Node2D
class_name Main


const MAIN_MENU: StringName = &"MainMenu"
const HUNTING: StringName = &"Hunting"
const BUTCHERING: StringName = &"Butchering"
const SHOPPING_CENTER: StringName = &"ShoppingCenter"
const IN_SHOP: StringName = &"InShop"

@export var hud: Node
@export var game_state_machine: StateMachine

func _ready() -> void:
	game_state_machine.register_state(MAIN_MENU, _enter_main_menu)
	game_state_machine.register_state(HUNTING, _enter_hunting, _exit_hunting)
	game_state_machine.register_state(BUTCHERING, _enter_butchering, _exit_butchering)
	game_state_machine.register_state(SHOPPING_CENTER, _enter_shopping_center)
	game_state_machine.register_state(IN_SHOP, _enter_shop, _exit_shop)


	Signals.hunt_round_complete.connect(func(): Gamemanager.request_state(BUTCHERING))
	Signals.butcher_round_complete.connect(func(): Gamemanager.request_state(SHOPPING_CENTER))
	Signals.shop_entered.connect(func(shop_id): Gamemanager.request_state(IN_SHOP, shop_id))
	Signals.shop_exited.connect(func(): Gamemanager.request_state(SHOPPING_CENTER))

	Signals.main_ready.emit()
	game_state_machine.change_states(MAIN_MENU)

func _physics_process(delta: float) -> void:
	game_state_machine.physics_process(delta)


func _enter_main_menu(_args = null) -> void:
	pass 

func _enter_hunting(_args = null) -> void:
	pass 

func _exit_hunting() -> void:
	pass 

func _enter_butchering(_args = null) -> void:
	pass 

func _exit_butchering() -> void:
	pass

func _enter_shopping_center(_args = null) -> void:
	pass 

func _enter_shop(shop_id) -> void:
	pass 

func _exit_shop() -> void:
	pass
