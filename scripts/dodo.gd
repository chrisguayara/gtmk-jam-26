extends Node2D
class_name Dodo

@export_group("Walking")
@export var walk_speed: float = 30.0

@export_group("Burst")
@export var burst_speed_min: float = 110.0
@export var burst_speed_max: float = 170.0
@export var burst_duration_min: float = 0.3
@export var burst_duration_max: float = 0.8

@export_group("Decision Timing")
@export var decision_delay_min: float = 1.0
@export var decision_delay_max: float = 3.0
@export_range(0.0, 1.0) var burst_chance: float = 0.45
@export_range(0.0, 1.0) var turn_chance: float = 0.3

@export_group("Screen Bounds")
@export var screen_margin: float = 50.0

@onready var sprite: Sprite2D = $Visual/Sprite2D

var _direction: float = 1.0
var _current_speed: float = 0.0

var _is_bursting: bool = false
var _burst_time_remaining: float = 0.0

var _decision_time_remaining: float = 0.0


func _ready() -> void:
	# Prevents the same spawn-order issue the rabbit had.
	call_deferred("_initialize_movement")


func _process(delta: float) -> void:
	if _is_bursting:
		_update_burst(delta)
	else:
		_update_walk(delta)

	_move_horizontally(delta)
	_handle_screen_edges()


func _initialize_movement() -> void:
	_direction = _random_direction()
	_current_speed = walk_speed
	_reset_decision_timer()
	_update_facing()


func _update_walk(delta: float) -> void:
	_current_speed = walk_speed

	_decision_time_remaining -= delta

	if _decision_time_remaining > 0.0:
		return

	_make_random_decision()
	_reset_decision_timer()


func _make_random_decision() -> void:
	# Sometimes turn around.
	if randf() < turn_chance:
		_direction *= -1.0
		_update_facing()

	# Sometimes start a short sprint.
	if randf() < burst_chance:
		_start_burst()


func _start_burst() -> void:
	_is_bursting = true

	_current_speed = randf_range(
		burst_speed_min,
		burst_speed_max
	)

	_burst_time_remaining = randf_range(
		burst_duration_min,
		burst_duration_max
	)


func _update_burst(delta: float) -> void:
	_burst_time_remaining -= delta

	if _burst_time_remaining <= 0.0:
		_finish_burst()


func _finish_burst() -> void:
	_is_bursting = false
	_current_speed = walk_speed
	_reset_decision_timer()


func _move_horizontally(delta: float) -> void:
	global_position.x += _direction * _current_speed * delta


func _handle_screen_edges() -> void:
	var screen_width := get_viewport_rect().size.x

	var left_edge := screen_margin
	var right_edge := screen_width - screen_margin

	if global_position.x <= left_edge:
		global_position.x = left_edge
		_direction = 1.0
		_update_facing()

	elif global_position.x >= right_edge:
		global_position.x = right_edge
		_direction = -1.0
		_update_facing()


func _reset_decision_timer() -> void:
	_decision_time_remaining = randf_range(
		decision_delay_min,
		decision_delay_max
	)


func _random_direction() -> float:
	if randf() < 0.5:
		return -1.0

	return 1.0


func _update_facing() -> void:
	sprite.flip_h = _direction < 0.0
