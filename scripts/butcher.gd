extends Node2D
class_name Butcher

@onready var animal = preload("res://objects/butchered_animal.tscn")
@onready var rabbit = preload("res://objects/butchered_bunny.tscn")
@onready var dodo = preload("res://objects/butchered_dodo.tscn")

@export var cuts_available: int = 5
@export var total_score: int = 0

@onready var slash: AudioStreamPlayer = $slash
@onready var slash_2: AudioStreamPlayer = $slash2

var _cuts_remaining: int = 0
var animals_to_butcher: Array[Resource] = []

signal next_animal


func setup(animals_caught: Array) -> void:
	animals_to_butcher.assign(animals_caught)
	print("Setup received:", animals_to_butcher.size())

	_start_butchering()


func _ready() -> void:
	_cuts_remaining = cuts_available
	Signals.butcher_started.emit()
	print("Butcher scene ready")


func _start_butchering() -> void:
	if animals_to_butcher.is_empty():
		print("No animals caught")
		return

	print("Starting butchering with:", animals_to_butcher.size())

	for animal_resource in animals_to_butcher:
		var butcher_scene: Resource = get_animal(animal_resource)
		var new_animal: Node = butcher_scene.instantiate()

		add_child(new_animal)

		new_animal.position = Vector2(-500, 0)
		new_animal.visible = true
		new_animal.done.connect(_on_butchered_animal_done)

		move_animal_to(new_animal, 0)

		await next_animal

		move_animal_to(new_animal, 1200)
		print("Move animal")


func get_animal(new_animal: Resource) -> Resource:
	var animal_node: Node = new_animal.instantiate()

	if animal_node is Rabbit:
		animal_node.queue_free()
		return rabbit

	if animal_node is Dodo:
		animal_node.queue_free()
		return dodo
	else:
		animal_node.queue_free()
		return animal


func make_cut() -> void:
	if _cuts_remaining <= 0:
		return

	_cuts_remaining -= 1
	Signals.butcher_cut_made.emit(_cuts_remaining)

	if _cuts_remaining <= 0:
		Signals.butcher_round_complete.emit()

	slash_2.play()


func _on_butchered_animal_done(score: int) -> void:
	total_score += score
	print("Let's goo!")

	next_animal.emit()
	slash.play()


func move_animal_to(creature: Node, target_x: float) -> Tween:
	var tween := create_tween()

	tween.tween_property(
		creature,
		"position:x",
		target_x,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	return tween


func _on_butchered_bunny_done(score: int) -> void:
	total_score += score
	next_animal.emit()


func _on_butchered_dodo_done(score: int) -> void:
	total_score += score
	next_animal.emit()
