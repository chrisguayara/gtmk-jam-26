class_name Arrow
extends Area2D

@export var minimum_speed: float = 1600.0
@export var maximum_speed: float = 2400.0
@export var fall_acceleration: float = 80.0

var _velocity: Vector2 = Vector2.ZERO
var _is_thrown: bool = false


func _physics_process(delta: float) -> void:
	if not _is_thrown:
		return

	_velocity.y += fall_acceleration * delta
	global_position += _velocity * delta


func throw(direction: Vector2, throw_power: float) -> void:
	if direction.is_zero_approx():
		return

	var normalized_power := clampf(throw_power, 0.0, 1.0)

	var speed := lerpf(
		minimum_speed,
		maximum_speed,
		normalized_power
	)

	_velocity = direction.normalized() * speed

	# Arrow points along its current flight direction.
	rotation = _velocity.angle()

	_is_thrown = true
