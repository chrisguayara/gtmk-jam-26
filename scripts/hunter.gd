class_name Hunter
extends Node2D

@onready var arm: Node2D = $arm
@onready var projectile_spawn: Marker2D = $arm/ProjectileSpawn

@export var arm_rotation_strength: float = 0.35
@export var max_arm_rotation_degrees: float = 35.0
@export var minimum_drag_distance: float = 30.0
@export var maximum_drag_distance: float = 300.0

var is_dragging := false
var drag_start := Vector2.ZERO
var drag_current := Vector2.ZERO

signal projectile_thrown(direction: Vector2, spawn_position: Vector2, throw_power: float)


func _process(_delta: float) -> void:
	if is_dragging:
		drag_current = get_global_mouse_position()
		update_arm_rotation()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()
			else:
				release_drag()


func start_drag() -> void:
	is_dragging = true
	drag_start = get_global_mouse_position()
	drag_current = drag_start


func release_drag() -> void:
	if not is_dragging:
		return

	is_dragging = false

	var drag_vector := drag_current - drag_start
	var drag_distance := drag_vector.length()

	if drag_distance < minimum_drag_distance:
		return

	var direction := -drag_vector.normalized()

	var throw_power := inverse_lerp(
		minimum_drag_distance,
		maximum_drag_distance,
		drag_distance
	)

	throw_power = clampf(throw_power, 0.0, 1.0)

	projectile_thrown.emit(
		direction,
		projectile_spawn.global_position,
		throw_power
	)


func update_arm_rotation() -> void:
	var drag_vector := drag_current - drag_start

	if drag_vector.length() < 5.0:
		return

	# Opposite of the drag direction.
	var shoot_direction := -drag_vector.normalized()
	var shoot_angle := shoot_direction.angle()

	# Only rotate partway toward the actual shooting angle.
	var toned_down_angle := shoot_angle * arm_rotation_strength

	var max_rotation := deg_to_rad(max_arm_rotation_degrees)

	arm.rotation = clamp(
		toned_down_angle,
		-max_rotation,
		max_rotation
	)
