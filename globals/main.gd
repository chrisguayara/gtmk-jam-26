extends Node2D
class_name Main


const MAIN_MENU: StringName = &"MainMenu"
const HUNTING: StringName = &"Hunting"
const BUTCHERING: StringName = &"Butchering"
const SHOPPING_CENTER: StringName = &"ShoppingCenter"
const IN_SHOP: StringName = &"InShop"

const MAIN_MENU_SCENE := preload("res://scenes/main_menu.tscn")
const HUNTING_SCENE := preload("res://scenes/hunt.tscn")
const BUTCHERING_SCENE := preload("res://scenes/butcher.tscn")
const SHOPPING_CENTER_SCENE := preload("res://scenes/shopping_center.tscn")

const SHOP_SCENES := {
	# example &"equipment_shop": preload("res://scenes/shop/equipment_shop.tscn"),
}

@export var hud: Node
@export var game_state_machine: StateMachine
@export var content_container: Node2D

var _active_screen: Node = null

func _ready() -> void:
	game_state_machine.register_state(MAIN_MENU, _enter_main_menu, _exit_screen)
	game_state_machine.register_state(HUNTING, _enter_hunting, _exit_screen)
	game_state_machine.register_state(BUTCHERING, _enter_butchering, _exit_screen)
	game_state_machine.register_state(SHOPPING_CENTER, _enter_shopping_center, _exit_screen)
	game_state_machine.register_state(IN_SHOP, _enter_shop, _exit_screen)

	# scene wiring
	Signals.hunt_round_complete.connect(func(): GameManager.request_state(BUTCHERING))
	Signals.butcher_round_complete.connect(func(): GameManager.request_state(SHOPPING_CENTER))
	Signals.shop_entered.connect(func(shop_id): GameManager.request_state(IN_SHOP, shop_id))
	Signals.shop_exited.connect(func(): GameManager.request_state(SHOPPING_CENTER))

	Signals.main_ready.emit()
	game_state_machine.change_states(MAIN_MENU)

func _physics_process(delta: float) -> void:
	game_state_machine.physics_process(delta)


func _swap_screen(scene: PackedScene) -> void:
	if _active_screen:
		_active_screen.queue_free()
		_active_screen = null
	if scene:
		_active_screen = scene.instantiate()
		content_container.add_child(_active_screen)


func _enter_main_menu(_args = null) -> void:
	_swap_screen(MAIN_MENU_SCENE)

func _enter_hunting(_args = null) -> void:
	_swap_screen(HUNTING_SCENE)

func _enter_butchering(_args = null) -> void:
	_swap_screen(BUTCHERING_SCENE)

func _enter_shopping_center(_args = null) -> void:
	_swap_screen(SHOPPING_CENTER_SCENE)

func _enter_shop(shop_id) -> void:
	_swap_screen(SHOP_SCENES.get(shop_id))

func _exit_screen() -> void:
	pass 
