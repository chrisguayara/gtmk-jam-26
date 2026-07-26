extends Node2D
class_name Hunt

@export var round_duration: float = 60.0
@export var max_animals_alive: int = 5
@export var spawn_interval: float = 2.0

@onready var round_timer: Timer = $RoundTimer
@onready var animal_container: Node2D = $AnimalContainer
@onready var projectile_container: Node2D = $ProjectileContainer
@onready var spawn_area: Node2D = $SpawnArea
@onready var hunter: Hunter = $Hunter
@export var animal_scenes: Array[PackedScene]
@export var weapon_scenes: Dictionary[StringName, PackedScene]
@onready var spawn_timer: Timer = $SpawnTimer
@export var equipped_weapon: StringName = &"rock"

var _animals_caught: Array[Resource] = []
var _round_active: bool = false

func _ready() -> void:
	
	if hunter.has_signal("projectile_thrown"):
		hunter.projectile_thrown.connect(_on_hunter_projectile_thrown)
	else:
		push_warning("Hunter does not have a projectile_thrown signal")
		
	round_timer.wait_time = round_duration
	round_timer.one_shot = true
	round_timer.timeout.connect(_on_round_timer_timeout)

	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	_start_round()


func _start_round() -> void:
	_animals_caught.clear()
	_round_active = true

	round_timer.start()
	spawn_timer.start()

	Signals.hunt_started.emit()


func _on_spawn_timer_timeout() -> void:
	if not _round_active:
		return

	if animal_container.get_child_count() >= max_animals_alive:
		return

	if animal_scenes.is_empty():
		return

	var selected_scene: PackedScene = animal_scenes.pick_random()
	_spawn_animal(selected_scene)


func _spawn_animal(animal_scene: PackedScene) -> void:
	var is_raven := animal_scene.resource_path.get_file() == "raven.tscn"
	var spawn_marker := _get_random_spawn_marker(is_raven)

	if spawn_marker == null:
		push_warning("No valid spawn marker found")
		return

	var animal := animal_scene.instantiate()
	animal_container.add_child(animal)

	animal.global_position = spawn_marker.global_position
	animal.scale *= _get_spawn_scale(spawn_marker)
	animal.z_index = _get_spawn_z_index(spawn_marker)
  
	if animal.has_signal("animal_caught"):
		animal.animal_caught.connect(_on_animal_caught)

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
	spawn_timer.stop()

	Signals.hunt_round_complete.emit(
		_animals_caught.duplicate()
	)

func _get_random_spawn_marker(use_sky_spawns: bool) -> Marker2D:
	var valid_markers: Array[Marker2D] = []

	for child in spawn_area.get_children():
		if child is not Marker2D:
			continue

		var marker := child as Marker2D
		var marker_name := marker.name.to_lower()

		if use_sky_spawns:
			if marker_name.begins_with("sky"):
				valid_markers.append(marker)
		else:
			if not marker_name.begins_with("sky"):
				valid_markers.append(marker)

	if valid_markers.is_empty():
		return null

	return valid_markers.pick_random()
	
func _get_spawn_scale(marker: Marker2D) -> float:
	var marker_name := marker.name.to_lower()

	if marker_name.begins_with("back"):
		return 0.55

	if marker_name.begins_with("mid"):
		return 0.7

	if marker_name.begins_with("front"):
		return 0.9

	if marker_name.begins_with("sky"):
		return 0.65

	return 1.0

func _get_spawn_z_index(marker: Marker2D) -> int:
	var marker_name := marker.name.to_lower()

	if marker_name.begins_with("back"):
		return 0

	if marker_name.begins_with("mid"):
		return 10

	if marker_name.begins_with("front"):
		return 20

	if marker_name.begins_with("sky"):
		return 5

	return 0

func _on_hunter_projectile_thrown(
	direction: Vector2,
	spawn_position: Vector2,
	throw_power: float
) -> void:
	spawn_projectile(
		direction,
		spawn_position,
		throw_power
	)

func spawn_projectile(
	direction: Vector2,
	spawn_position: Vector2,
	throw_power: float
) -> void:
	if not _round_active:
		return

	if direction.is_zero_approx():
		return

	var projectile_scene: PackedScene = weapon_scenes.get(equipped_weapon)

	if projectile_scene == null:
		push_warning(
			"No projectile scene assigned for weapon: "
			+ str(equipped_weapon)
		)
		return

	if not EquipmentManager.consume_item(equipped_weapon):
		print("No ", equipped_weapon, " remaining")
		return

	var projectile := projectile_scene.instantiate()
	projectile_container.add_child(projectile)

	projectile.global_position = spawn_position

	if projectile.has_method("throw"):
		projectile.throw(direction, throw_power)
	else:
		push_warning(
			str(equipped_weapon)
			+ "'s projectile scene has no throw method"
		)

		EquipmentManager.add_item(equipped_weapon)
		projectile.queue_free()
