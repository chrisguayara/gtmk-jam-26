extends Node2D
class_name Butcher
var assets: Array = preload_folder("res://assets/placeholders/ButcherPartsGeneric")
@onready var animal = get_node("ButcheredAnimal")

@export var cuts_available: int = 5
var _cuts_remaining: int = 0




func _ready() -> void:
	_cuts_remaining = cuts_available
	Signals.butcher_started.emit()
	print("butcher ready!")
	
	
	
	if animal.readied_lines == false:
		await animal.lines_readied
	print("textures added")
	animal.set_textures(assets.slice(1))
	
	animal.position.x = -500
	move_animal_to(640)
	

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
