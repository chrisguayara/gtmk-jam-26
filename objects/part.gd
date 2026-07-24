extends RigidBody2D

@export var jump_force: float = 400.0
@export var spin_speed: float = 10.0  # radians/sec

func _ready() -> void:
	freeze = true

func jump_and_spin(extra_force: float = 0) -> void:
	freeze = false
	# Impulse gives an instant velocity change (good for jumps, unlike forces which build up over time)
	apply_central_impulse(Vector2(0, -jump_force - extra_force))
	
	# Angular velocity directly sets spin speed (positive = clockwise in Godot's coordinate system)
	angular_velocity = spin_speed
	


func _physics_process(_delta):
	pass
