extends Area2D
class_name Axe

@export_category("Throw")
@export var minimum_speed: float = 400.0
@export var maximum_speed: float = 900.0

@export_category("Arc")
@export var upward_velocity_min: float = 350.0
@export var upward_velocity_max: float = 650.0
@export var fall_acceleration: float = 1200.0

@export_category("Spin")
@export var spin_speed_min: float = 8.0
@export var spin_speed_max: float = 16.0

@export_category("Depth")
@export var final_scale_multiplier: float = 0.5

@export_category("Lifetime")
@export var lifetime: float = 4.0

var _velocity: Vector2 = Vector2.ZERO
var _spin_speed: float = 0.0
var _was_thrown: bool = false

var _starting_scale: Vector2
var _ending_scale: Vector2
var _elapsed: float = 0.0


func throw(direction: Vector2, throw_power: float) -> void:
	if direction.is_zero_approx():
		return

	throw_power = clampf(throw_power, 0.0, 1.0)

	var speed := lerpf(
		minimum_speed,
		maximum_speed,
		throw_power
	)

	var upward_velocity := lerpf(
		upward_velocity_min,
		upward_velocity_max,
		throw_power
	)

	_velocity = direction.normalized() * speed

	# Adds a stronger upward arc regardless of mouse direction.
	_velocity.y -= upward_velocity

	_spin_speed = lerpf(
		spin_speed_min,
		spin_speed_max,
		throw_power
	)

	_starting_scale = scale
	_ending_scale = scale * final_scale_multiplier

	_elapsed = 0.0
	_was_thrown = true

	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	if not _was_thrown:
		return

	_elapsed += delta

	# Projectile movement
	_velocity.y += fall_acceleration * delta
	global_position += _velocity * delta

	# Axe rotation
	rotation += _spin_speed * delta

	# Depth illusion
	var scale_progress := clampf(_elapsed / lifetime, 0.0, 1.0)
	scale = _starting_scale.lerp(
		_ending_scale,
		scale_progress
	)
