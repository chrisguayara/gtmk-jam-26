extends butchered_animal

func _init() -> void:
	sprite_sheet = preload("res://assets/sprites/butchered_animals/dodo.png") 
	limbsCoordiates = [
	Vector2(12,-10),Vector2(-9,-10),
	Vector2(-58,25),Vector2(-47,35),
	Vector2(-2,33),Vector2(8,29),
	]
	limb_scale = .15 
	score = 2500
	frame_width = 128
	frame_height = 128
	columns = 4
	
	
func _ready() -> void:
	super()
	create_offset(0,Vector2(0,8))
	create_offset(1,Vector2(50,-35))
	create_offset(2,Vector2(0,-35))
