class_name Animal
extends Node2D

@export var max_hp: float = 10.0
@export var move_speed: float = 100.0
@export var score_value: int = 100

var current_hp: float


func _ready() -> void:
	current_hp = max_hp

# Child scripts replace this function.
func move(_delta: float) -> void:
	pass


func take_damage(damage: float) -> void:
	current_hp -= damage

	if current_hp <= 0:
		die()


func die() -> void:
	queue_free()
