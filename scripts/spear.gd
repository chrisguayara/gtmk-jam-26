extends Area2D
class_name Spear


enum MovementPhase {
	NOT_THROWN,
	STRAIGHT,
	DROPPING
}


@export_category("Throw Speed")
@export var minimum_speed: float = 500.0
@export var maximum_speed: float = 1200.0
@export var straight_flight_duration: float = 0.45

@export_category("Drop")
@export var drop_distance: float = 180.0
@export var drop_duration: float = 0.35

@export_category("Depth Scaling")
@export var final_scale_multiplier: float = 0.4


var _phase: MovementPhase = MovementPhase.NOT_THROWN
var _direction: Vector2 = Vector2.ZERO
var _speed: float = 0.0

var _phase_elapsed: float = 0.0
var _drop_start_position: Vector2

var _starting_scale: Vector2
var _ending_scale: Vector2

var _total_elapsed: float = 0.0
var _total_duration: float = 0.0


func throw(direction: Vector2, throw_power: float) -> void:
	if direction.is_zero_approx():
		return

	throw_power = clampf(throw_power, 0.0, 1.0)

	_direction = direction.normalized()
	_speed = lerpf(minimum_speed, maximum_speed, throw_power)

	rotation = _direction.angle()

	_starting_scale = scale
	_ending_scale = _starting_scale * final_scale_multiplier

	_phase = MovementPhase.STRAIGHT
	_phase_elapsed = 0.0
	_total_elapsed = 0.0
	_total_duration = straight_flight_duration + drop_duration


func _physics_process(delta: float) -> void:
	if _phase == MovementPhase.NOT_THROWN:
		return

	_phase_elapsed += delta
	_total_elapsed += delta

	_update_depth_scale()

	match _phase:
		MovementPhase.STRAIGHT:
			_process_straight_flight(delta)

		MovementPhase.DROPPING:
			_process_drop()


func _process_straight_flight(delta: float) -> void:
	global_position += _direction * _speed * delta

	if _phase_elapsed >= straight_flight_duration:
		_begin_drop()


func _begin_drop() -> void:
	_phase = MovementPhase.DROPPING
	_phase_elapsed = 0.0
	_drop_start_position = global_position


func _process_drop() -> void:
	var progress := clampf(
		_phase_elapsed / drop_duration,
		0.0,
		1.0
	)

	global_position.y = lerpf(
		_drop_start_position.y,
		_drop_start_position.y + drop_distance,
		progress
	)

	if progress >= 1.0:
		queue_free()


func _update_depth_scale() -> void:
	var progress := clampf(
		_total_elapsed / _total_duration,
		0.0,
		1.0
	)

	scale = _starting_scale.lerp(
		_ending_scale,
		progress
	)
