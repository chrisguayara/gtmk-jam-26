class_name SlingRock
extends Area2D

@export var minimum_speed: float = 1100.0
@export var maximum_speed: float = 1800.0
@export var fall_acceleration: float = 180.0

@export var minimum_spin_speed: float = 4.0
@export var maximum_spin_speed: float = 8.0

var _velocity: Vector2 = Vector2.ZERO
var _spin_speed: float = 0.0
var _is_thrown: bool = false

@onready var sprite: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	if not _is_thrown:
		return

	# Small amount of vertical drop.
	_velocity.y += fall_acceleration * delta

	global_position += _velocity * delta

	# Rotate only the visual, like the normal rock.
	sprite.rotation += _spin_speed * delta


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

	_spin_speed = lerpf(
		minimum_spin_speed,
		maximum_spin_speed,
		normalized_power
	)

	_is_thrown = true
