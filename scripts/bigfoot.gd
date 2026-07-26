extends Node2D
class_name Bigfoot


@export_group("Movement")
@export var walk_speed: float = 45.0


@export_group("Screen Bounds")
@export var horizontal_margin: float = 50.0

signal animal_caught(animal_data: Resource)
var _caught: bool = false
@export var animal_data: Resource
@export var hit_points: int = 40
@onready var hitbox: Area2D = $hitbox
@onready var sprite: Sprite2D = $Visual/Sprite2D

var _direction: float = 1.0
var _movement_initialized: bool = false


func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)
	call_deferred("_initialize_movement")


func _process(delta: float) -> void:
	if not _movement_initialized:
		return

	global_position.x += _direction * walk_speed * delta

	_handle_screen_edges()


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
			damage = 3

		"sling":
			damage = 5

		"spear":
			damage = 10

		"axe":
			damage = 15

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
	_direction = _random_sign()

	_update_facing()

	_movement_initialized = true


func _handle_screen_edges() -> void:
	var screen_width := get_viewport_rect().size.x

	var left_edge := horizontal_margin
	var right_edge := screen_width - horizontal_margin

	if global_position.x <= left_edge:
		global_position.x = left_edge
		_direction = 1.0
		_update_facing()

	elif global_position.x >= right_edge:
		global_position.x = right_edge
		_direction = -1.0
		_update_facing()


func _random_sign() -> float:
	if randf() < 0.5:
		return -1.0

	return 1.0


func _update_facing() -> void:
	sprite.flip_h = _direction < 0.0
