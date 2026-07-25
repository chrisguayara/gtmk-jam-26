extends Node2D
class_name Rabbit

@export var hop_distance_min: float = 80.0
@export var hop_distance_max: float = 160.0
@export var hop_duration: float = 0.45
@export var hop_height: float = 30.0
@export var pause_duration_min: float = 0.2
@export var pause_duration_max: float = 0.8

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visual: Node2D = $Visual
@onready var sprite: Sprite2D = $Visual/Sprite2D

var _is_hopping: bool = false
var _hop_start: Vector2
var _hop_target: Vector2
var _hop_time: float = 0.0
var _visual_start_position: Vector2


func _ready() -> void:
	_visual_start_position = visual.position
	_start_next_hop()


func _process(delta: float) -> void:
	if not _is_hopping:
		return

	_hop_time += delta

	var progress := clampf(
		_hop_time / hop_duration,
		0.0,
		1.0
	)

	# Smooth movement from the starting point to the target.
	var movement_progress := smoothstep(
		0.0,
		1.0,
		progress
	)

	global_position = _hop_start.lerp(
		_hop_target,
		movement_progress
	)

	# Creates the upward-and-downward hop arc.
	var vertical_offset := sin(progress * PI) * hop_height

	visual.position = _visual_start_position + Vector2(
		0.0,
		-vertical_offset
	)

	if progress >= 1.0:
		_finish_hop()


func _start_next_hop() -> void:
	var direction := Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-0.15, 0.15)
	).normalized()

	var distance := randf_range(
		hop_distance_min,
		hop_distance_max
	)

	_hop_start = global_position
	_hop_target = global_position + direction * distance
	_hop_time = 0.0
	_is_hopping = true

	_update_facing(direction)

	if animation_player.has_animation("hop"):
		animation_player.play("hop")


func _finish_hop() -> void:
	_is_hopping = false
	visual.position = _visual_start_position

	await get_tree().create_timer(
		randf_range(
			pause_duration_min,
			pause_duration_max
		)
	).timeout

	_start_next_hop()


func _update_facing(direction: Vector2) -> void:
	if direction.x == 0.0:
		return

	sprite.flip_h = direction.x < 0.0
