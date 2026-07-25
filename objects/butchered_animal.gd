extends StaticBody2D
const cutting = preload("res://objects/cutting_line.tscn")
@export var assets: Array 
@export var score: int = 5000
var cuttingLines: Array
const limbsCoordiates: Array = [
	Vector2(60,-63),Vector2(94,-38),
	Vector2(60,63),Vector2(94,38),
	Vector2(-60,63),Vector2(-94,38),
	Vector2(-60,-63),Vector2(-94,-38),
]
var readied_lines = false

@onready var label = get_node("Label")

signal lines_readied
signal done
# Called when the node enters the scene tree for the first time.
var cuts: int
func _ready() -> void:
	var cuttingLine = cutting.instantiate()
	add_child(cuttingLine)
	cuttingLine.activate(Vector2(100,30),Vector2(100,-30),.5)

	for i in range(len(limbsCoordiates)/2):
		var line = cutting.instantiate()
		add_child(line)
		line.activate(limbsCoordiates[i*2],limbsCoordiates[i*2+1],.4)
	
	#Add it to an array
	for child in get_children():
		if child is CuttingLine:
			cuttingLines.append(child)
			child.finished_cutting.connect(scoring)
	cuts = len(cuttingLines)
	print("lines are ready.")
	readied_lines = true
	lines_readied.emit()
	

func scoring(subtracted_score: int) -> void:
	print(subtracted_score)
	subtracted_score = clamp(subtracted_score-100,0,1000) #You get 100 discount, and you can only lose max 1000
	#This score DETACHES value from the meat!
	
	score -= clamp(subtracted_score,0,5000)
	cuts -= 1
	if cuts <= 0:
		done.emit()
		



func set_textures(textures: Array) -> void:
 
	for i in range(len(textures)):
		if i >= len(cuttingLines):
			break
		print("texture set! ", textures[i] )
		cuttingLines[i].setTexture(textures[i])
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(score)

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
