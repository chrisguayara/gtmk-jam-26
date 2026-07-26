extends Node2D
class_name Raven


signal animal_caught(animal_data: Resource)

@export var animal_data: Resource

@export_group("Movement")
@export var speed_min: float = 100.0
@export var speed_max: float = 220.0

@export var vertical_direction_change_min: float = 0.4
@export var vertical_direction_change_max: float = 1.0
@export var hit_points: int = 5

@export_group("Roaming Area")
@export var vertical_roam_up: float = 100.0
@export var vertical_roam_down: float = 80.0
var _caught: bool = false

@export_group("Screen Bounds")
@export var horizontal_margin: float = 50.0


@onready var sprite: Sprite2D = $Visual/Sprite2D
@onready var hitbox: Area2D = $hitbox

var _horizontal_direction: float = 1.0
var _vertical_direction: float = 1.0

var _current_speed: float = 0.0
var _direction_change_time_remaining: float = 0.0

var _spawn_y: float = 0.0
var _vertical_min: float = 0.0
var _vertical_max: float = 0.0

var _movement_initialized: bool = false


func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)
	call_deferred("_initialize_movement")


func _process(delta: float) -> void:
	if not _movement_initialized:
		return

	_direction_change_time_remaining -= delta

	if _direction_change_time_remaining <= 0.0:
		_change_flight_pattern()

	var direction := Vector2(
		_horizontal_direction,
		_vertical_direction
	).normalized()

	global_position += direction * _current_speed * delta

	_handle_bounds()

func _on_area_entered(area: Area2D) -> void:
	if _caught:
		return

	if not area.is_in_group("Projectile"):
		return

	var projectile_name := area.name.to_lower()
	var damage: int = 0

	print("Projectile hit: ", projectile_name)

	match projectile_name:
		"rock":
			damage = 5

		"sling":
			damage = 12

		"spear":
			damage = 15

		"axe":
			damage = 20

		"bow":
			damage = 30
		_:
			push_warning("Unknown projectile: " + projectile_name)
			return

	hit_points -= damage
	area.queue_free()

	print(
		name,
		" took ",
		damage,
		" damage. HP remaining: ",
		hit_points
	)

	if hit_points <= 0:
		_caught = true
		hitbox.set_deferred("monitoring", false)

		animal_caught.emit(animal_data)
		queue_free()

func _initialize_movement() -> void:
	# Save the Y coordinate of whichever sky marker
	# this raven spawned from.
	_spawn_y = global_position.y

	_vertical_min = _spawn_y - vertical_roam_up
	_vertical_max = _spawn_y + vertical_roam_down

	_horizontal_direction = _random_sign()
	_vertical_direction = _random_sign()

	_current_speed = randf_range(
		speed_min,
		speed_max
	)

	_reset_direction_change_timer()
	_update_facing()

	_movement_initialized = true


func _change_flight_pattern() -> void:
	# Flip between diagonal-up and diagonal-down movement.
	_vertical_direction *= -1.0

	# Pick a new speed whenever the direction changes.
	_current_speed = randf_range(
		speed_min,
		speed_max
	)

	_reset_direction_change_timer()


func _handle_bounds() -> void:
	var screen_width := get_viewport_rect().size.x

	var left_edge := horizontal_margin
	var right_edge := screen_width - horizontal_margin

	# Horizontal screen limits.
	if global_position.x <= left_edge:
		global_position.x = left_edge
		_horizontal_direction = 1.0
		_update_facing()

	elif global_position.x >= right_edge:
		global_position.x = right_edge
		_horizontal_direction = -1.0
		_update_facing()

	# Vertical roaming limits relative to spawn height.
	if global_position.y <= _vertical_min:
		global_position.y = _vertical_min
		_vertical_direction = 1.0

	elif global_position.y >= _vertical_max:
		global_position.y = _vertical_max
		_vertical_direction = -1.0


func _reset_direction_change_timer() -> void:
	_direction_change_time_remaining = randf_range(
		vertical_direction_change_min,
		vertical_direction_change_max
	)


func _random_sign() -> float:
	if randf() < 0.5:
		return -1.0

	return 1.0


func _update_facing() -> void:
	sprite.flip_h = _horizontal_direction < 0.0
