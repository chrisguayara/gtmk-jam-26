extends Node2D
class_name Butcher
var assets: Array = preload_folder("res://assets/placeholders/ButcherPartsGeneric")
@onready var animal = get_node("butchered_dodo") #Change this to test. 

#Look into butchered_bunny script for a guide on how to make a new butchered animal.
#You should duplicate the scene. Then you want to extend a new script. Sloppy work I know.
#Try linking the animals caught queue and make a dictionary between the caught animals and the butchered animals

# Oh yeah, when you make a new butchered animal, connect a new signal (the signal name is "done")

#TODO Add a popping sound on cut. Should be simple.

@export var cuts_available: int = 5
var _cuts_remaining: int = 0

var animals_to_butcher: Array[Resource] = []

func setup(animals_caught: Array) -> void:
	animals_to_butcher = animals_caught

func _ready() -> void:
	_cuts_remaining = cuts_available
	Signals.butcher_started.emit()
	print("butcher ready!")
	
	
	
	if animal.readied_lines == false:
		await animal.lines_readied

	
	animal.position.x = -500
	animal.position.y = 360
	move_animal_to(320)
	

func make_cut() -> void:
	if _cuts_remaining <= 0:
		return
	_cuts_remaining -= 1
	Signals.butcher_cut_made.emit(_cuts_remaining)
	if _cuts_remaining <= 0:
		Signals.butcher_round_complete.emit()
		

func preload_folder(path: String) -> Array:
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	files.sort()  # alphabetical order

	var result = []
	for f in files:
		result.append(load(path + "/" + f))
	return result

func _process(delta: float) -> void:
	pass
	

func _on_butchered_animal_done() -> void:
	var tween = move_animal_to(1500)
	await tween.finished
	Signals.butcher_round_complete.emit(animal.score)
	#broadcast signal here

func move_animal_to(target_x: float) -> Tween:
	var tween = create_tween()
	tween.tween_property(animal, "position:x", target_x, 1.0)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_OUT)
	return tween


func _on_butchered_bunny_done() -> void:
	var tween = move_animal_to(1500)
	await tween.finished
	Signals.butcher_round_complete.emit(animal.score)
