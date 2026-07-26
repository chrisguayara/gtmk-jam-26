class_name butchered_animal
extends StaticBody2D
const cutting = preload("res://objects/cutting_line.tscn")

var sprite_sheet: Resource
var frame_width := 128
var frame_height := 128
var columns := 5
var rows := 1

@export var assets: Array 
@export var score: int = 5000
var cutting_lines: Array
var limbsCoordiates: Array = [
	Vector2(100,30),Vector2(100,-30),
	Vector2(60,-63),Vector2(94,-38),
	Vector2(60,63),Vector2(94,38),
	Vector2(-60,63),Vector2(-94,38),
	Vector2(-60,-63),Vector2(-94,-38),
]
var readied_lines = false
var limb_scale = .4
@onready var label = get_node("Label")

signal lines_readied
signal done
# Called when the node enters the scene tree for the first time.
var cuts: int
func _ready() -> void:
	

	for i in range(len(limbsCoordiates)/2):
		var line = cutting.instantiate()
		add_child(line)
		line.activate(limbsCoordiates[i*2],limbsCoordiates[i*2+1],limb_scale)
	
	#Add it to an array
	for child in get_children():
		if child is CuttingLine:
			cutting_lines.append(child)
			child.finished_cutting.connect(scoring)
	cuts = len(cutting_lines)
	print("lines are ready.")
	readied_lines = true
	lines_readied.emit()
	if sprite_sheet:
		var frames: Array[Texture2D] = []
		for row in rows:
			for col in columns:
				var atlas := AtlasTexture.new()
				atlas.atlas = sprite_sheet
				atlas.region = Rect2(col * frame_width, row * frame_height, frame_width, frame_height)
				frames.append(atlas)
		set_textures(frames.slice(1))
	

func scoring(subtracted_score: int) -> void:
	print(subtracted_score)
	subtracted_score = clamp(subtracted_score-100,0,1000) #You get 100 discount, and you can only lose max 1000
	#This score DETACHES value from the meat!
	
	score -= clamp(subtracted_score,0,5000)
	cuts -= 1
	if cuts <= 0:
		done.emit()
		



func set_textures(textures: Array[Texture2D]) -> void:
 
	for i in range(len(textures)):
		if i >= len(cutting_lines):
			break
		print("texture set! ", textures[i] )
		cutting_lines[i].setTexture(textures[i])
		
func create_offset(index: int, offset: Vector2, rotation: int = 0) -> void:
	var part = cutting_lines[index].get_node("Part").get_node("Sprite2D")
	part.position = offset
	if rotation != 0:
		cutting_lines[index].get_node("Part").get_node("Sprite2D").rotation += rotation
	#This code is ugly at best
	
	
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
