extends Node2D
class_name Mammoth


signal animal_caught(animal_data: Resource)

@export var animal_data: Resource


@export_group("Movement")
@export var walk_speed: float = 30.0


@export_group("Screen Bounds")
@export var horizontal_margin: float = 80.0


@onready var hitbox: Area2D = $hitbox
@onready var sprite: Sprite2D = $Visual/Sprite2D


var _direction: float = 1.0
var _movement_initialized: bool = false
var _caught: bool = false


func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)

	# Wait until Hunt finishes placing the mammoth at its spawn marker.
	call_deferred("_initialize_movement")


func _process(delta: float) -> void:
	if not _movement_initialized or _caught:
		return

	global_position.x += _direction * walk_speed * delta

	_handle_screen_edges()


func _on_area_entered(area: Area2D) -> void:
	if _caught:
		return

	if not area.is_in_group("Projectile"):
		return

	_caught = true
	_movement_initialized = false
	hitbox.set_deferred("monitoring", false)

	animal_caught.emit(animal_data)

	area.queue_free()
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
