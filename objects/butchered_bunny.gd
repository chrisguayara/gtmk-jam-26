extends butchered_animal

	
func _init() -> void:
	sprite_sheet = preload("res://assets/sprites/butchered_animals/bunny.png") #Change this!
	frame_width = 128
	frame_height = 128
	columns = 5
	limbsCoordiates = [ #THEY ARE LOCAL!
	Vector2(-28,7),Vector2(-18,18),
	Vector2(28,7),Vector2(8,18),
	Vector2(12,-20),Vector2(28,0),
	Vector2(-25,-10),Vector2(-25,10),
	]
	#First sprite is always the body. You should set that manually. 
	#Coordinates correspond to index location
	limb_scale = .15  #Changes how big the cuts are. 
	score = 2000
	
func _ready() -> void:
	
	# Offset lets you shift the position of a part
	#Parameter 1: Part number. Corresponds to limbsCoordinates. By default, the parts spawn at the MIDPOINT of the line
	#Parameter 2: Shift amount. 
	#Parameter 3: Rotation amount (degrees)
	super()
	create_offset(0,Vector2(-7,0))
	create_offset(1,Vector2(5,0))
	create_offset(2,Vector2(15,-15),-45)
