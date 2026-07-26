extends butchered_animal

func _init() -> void:
	sprite_sheet = preload("res://assets/sprites/butchered_animals/dodo.png") 
	limbsCoordiates = [
	Vector2(-28,7),Vector2(-18,18),
	Vector2(28,7),Vector2(8,18),
	Vector2(12,-20),Vector2(28,0),
	]
	limb_scale = .15 
func _ready() -> void:
	super()
	create_offset(0,Vector2(-7,0))
	create_offset(1,Vector2(5,0))
	create_offset(2,Vector2(15,-15),-45)
