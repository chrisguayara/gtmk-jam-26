extends Node2D
class_name Butcher
@onready var animal = preload("res://objects/butchered_animal.tscn") #Change this to test. 
@onready var rabbit = preload("res://objects/butchered_bunny.tscn")
@onready var dodo = preload("res://objects/butchered_dodo.tscn")
#Look into butchered_bunny script for a guide on how to make a new butchered animal.
#You should duplicate the scene. Then you want to extend a new script. Sloppy work I know.
#Try linking the animals caught queue and make a dictionary between the caught animals and the butchered animals

# Oh yeah, when you make a new butchered animal, connect a new signal (the signal name is "done")

#TODO Add a popping sound on cut. Should be simple.

@export var cuts_available: int = 5
var _cuts_remaining: int = 0
@export var total_score: int = 0
@onready var slash: AudioStreamPlayer = $slash

@onready var slash_2: AudioStreamPlayer = $slash2


var animals_to_butcher: Array[Resource] = []

func get_animal(new_animal: Resource) -> Resource:
	var animal_node = new_animal.instantiate()
	if animal_node is Rabbit:
		animal_node.queue_free()
		return rabbit
	if animal_node is Dodo:
		animal_node.queue_free()
		return dodo
	else:
		animal_node.queue_free()
		return animal
		

func setup(animals_caught: Array) -> void:
	animals_to_butcher = animals_caught

func _ready() -> void:
	
	#Insert array HERE
	
	if len(animals_to_butcher) == 0:
		animals_to_butcher.append(load("res://scenes/animals/mammoth.tscn"))
		animals_to_butcher.append(load("res://scenes/animals/rabbit.tscn"))
		animals_to_butcher.append(load("res://scenes/animals/dodo.tscn"))
		animals_to_butcher.append(load("res://scenes/animals/mammoth.tscn"))
		animals_to_butcher.append(load("res://scenes/animals/rabbit.tscn"))
		animals_to_butcher.append(load("res://scenes/animals/dodo.tscn"))
	if len(animals_to_butcher) < 0:
		animals_to_butcher.append(load("res://scenes/animals/mammoth.tscn"))

	_cuts_remaining = cuts_available
	Signals.butcher_started.emit()
	print("butcher ready!")
	#get_animal(load("res://scenes/animals/rabbit.tscn"))

	for animal in animals_to_butcher: #MAIN LOOP
		var butcher = get_animal(animal)
		
		var new_animal = butcher.instantiate()
		add_child(new_animal)
		new_animal.position.x = -500
		new_animal.position.y = 0
		new_animal.visible = true
		new_animal.done.connect(_on_butchered_animal_done)
		move_animal_to(new_animal,0)
		await next_animal
		move_animal_to(new_animal,1200)
		print("move animal.")
	print("total score is: " + str(total_score))
	RunManager.wallet = RunManager.wallet + (total_score / 100)
	Signals.butcher_round_complete.emit()

	print(RunManager.wallet)
	#End here

func make_cut() -> void:
	if _cuts_remaining <= 0:
		return
	_cuts_remaining -= 1
	Signals.butcher_cut_made.emit(_cuts_remaining)
	if _cuts_remaining <= 0:
		Signals.butcher_round_complete.emit()
		
	slash_2.play()



func _process(delta: float) -> void:
	pass

signal next_animal

func _on_butchered_animal_done(score: int) -> void:
	total_score += score
	print("let's goo!")
	next_animal.emit()
	slash.play()
	#broadcast signal here

func move_animal_to(creature: Node, target_x: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(creature, "position:x", target_x, 1.0)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_OUT)
	return tween


func _on_butchered_bunny_done(score: int) -> void:
	total_score += score
	next_animal.emit()

func _on_butchered_dodo_done(score: int) -> void:
	total_score += score
	next_animal.emit()
