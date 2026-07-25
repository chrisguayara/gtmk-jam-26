extends Node2D
class_name Hunt

@export var round_duration: float = 60.0

@onready var round_timer: Timer = $RoundTimer
@onready var animal_container: Node2D = $AnimalContainer
@onready var projectile_container: Node2D = $ProjectileContainer
@onready var spawn_area: Node2D = $SpawnArea
@onready var hunter: Node2D = $Hunter

var _animals_caught: Array[Resource] = []
var _round_active: bool = false

func _ready() -> void:
	round_timer.wait_time = round_duration
	round_timer.one_shot = true
	round_timer.timeout.connect(_on_round_timer_timeout)

	_start_round()


func _start_round() -> void:
	_animals_caught.clear()
	_round_active = true

	round_timer.start()
	Signals.hunt_started.emit()


func throw_tool() -> void:
	if not _round_active:
		return

	# Spawn the projectile here.
	# No item consumption unless you still want limited ammunition.


func _on_animal_caught(animal_data: Resource) -> void:
	if not _round_active:
		return

	_animals_caught.append(animal_data)
	Signals.hunt_animal_caught.emit(animal_data)


func _on_round_timer_timeout() -> void:
	_end_round()


func _end_round() -> void:
	if not _round_active:
		return

	_round_active = false

	Signals.hunt_round_complete.emit(
		_animals_caught.duplicate()
	)
