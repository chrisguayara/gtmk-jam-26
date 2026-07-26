extends RigidBody2D

@export var jump_force: float = 500.0
@onready var parent = get_parent()

func _ready() -> void:
	freeze = true

func jump_and_spin(extra_force: float = 0) -> void:
	freeze = false
	scale = Vector2(1.0 / parent.scale.x, 1.0 / parent.scale.y)
	# Impulse gives an instant velocity change (good for jumps, unlike forces which build up over time)
	var horizontal = randf_range(-200.0, 200.0)
	var spin_speed: float = randf_range(15, 25) 
	apply_central_impulse(Vector2(horizontal, -jump_force - extra_force))
	
	# Angular velocity directly sets spin speed (positive = clockwise in Godot's coordinate system)
	angular_velocity = spin_speed
	


func _physics_process(_delta):
	if position.y > 2000:
		
		visible = false
