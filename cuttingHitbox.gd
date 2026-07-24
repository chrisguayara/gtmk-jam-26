extends Node2D

@onready var endPoint1 = get_node("CutNode1")
@onready var endPoint2 = get_node("CutNode2")
@onready var part = get_node("Part")
var swept_area = null
# Called when the node enters the scene tree for the first time.

var ready_to_be_cut = false
var cutting = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func activate(firstPosition: Vector2,secondPosition: Vector2,scale: float = 1) -> void:
	
	print("ready!")
	endPoint1.scale = Vector2(scale, scale)
	endPoint2.scale = Vector2(scale, scale)
	endPoint1.position = firstPosition
	endPoint2.position = secondPosition
	var swept_shape = generate_swept_collision(endPoint1, endPoint2)
	swept_area = Area2D.new()
	swept_area.add_child(swept_shape)
	add_child(swept_area)
	
	part.position = (endPoint1.global_position + endPoint2.global_position) / 2.0
	
	
		
	
	process_mode = Node.PROCESS_MODE_INHERIT

var lastMousePosition
var otherEndPoint
var score = 0
var done = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Check if we should enter or exit cutting mode.
	if done == true: return
	if ready_to_be_cut && Input.is_action_just_pressed("mouse_down") && not cutting:
		cutting = true
		lastMousePosition = get_global_mouse_position()
		
		if mouse_is_touching_rect(endPoint1):
			otherEndPoint = endPoint2
		else:
			otherEndPoint = endPoint1
		return 
		#Set first mouse positiion and start processing
	if not Input.is_action_pressed("mouse_down") || !mouse_is_touching(swept_area):
		cutting = false
		
		if mouse_is_touching_rect(otherEndPoint):
			
			part.jump_and_spin(score/4)
			print(score)
			
			done = true

	if not cutting: 
		return
	#This part only runs when you are in cutting mode
	var currentMousePosition = get_global_mouse_position()
	var magnitude = lastMousePosition.distance_to(currentMousePosition)
	
	var cuttingValue = magnitude / delta
	if cuttingValue > score: score = cuttingValue
	
	lastMousePosition = get_global_mouse_position()
	
	

func mouse_is_touching(area: Area2D) -> bool: #For polygons
	var poly_node = area.get_child(0) as CollisionPolygon2D
	var local_mouse = poly_node.global_transform.affine_inverse() * get_global_mouse_position()
	return Geometry2D.is_point_in_polygon(local_mouse, poly_node.polygon)

#Grab the actual global points of a rectangle
func get_global_points(area: Area2D) -> PackedVector2Array:
	var points := PackedVector2Array()
	
	var shape = area.get_child(0) 
	assert(shape.shape is RectangleShape2D, "Rectangle collision shape needed!")


	var rectangle_resource = shape.shape
	var xform = shape.global_transform
	var half_size = rectangle_resource.size / 2.0  # Godot 4; use shape.extents in Godot 3

	var local_pts = [
		Vector2(-half_size.x, -half_size.y),
		Vector2(half_size.x, -half_size.y),
		Vector2(half_size.x, half_size.y),
		Vector2(-half_size.x, half_size.y),
	]

	for p in local_pts:
		points.append(xform * p)

	return points

func mouse_is_touching_rect(area: Area2D) -> bool: #For rectangles
	if not area:
		return false
	var shape_node = area.get_child(0) as CollisionShape2D
	var rect_shape = shape_node.shape as RectangleShape2D
	var half_size = rect_shape.size / 2.0
	var box = Rect2(-half_size, rect_shape.size)
	var local_mouse = shape_node.global_transform.affine_inverse() * get_global_mouse_position()
	return box.has_point(local_mouse)

func generate_swept_collision(area_a: Area2D, area_b: Area2D) -> CollisionPolygon2D:
	var points_a = get_global_points(area_a)
	var points_b = get_global_points(area_b)

	var all_points := PackedVector2Array()
	all_points.append_array(points_a)
	all_points.append_array(points_b)

	var hull = Geometry2D.convex_hull(all_points)

	var poly = CollisionPolygon2D.new()
	poly.polygon = hull
	return poly


func _on_cut_node_1_mouse_entered() -> void:
	ready_to_be_cut = true


func _on_cut_node_1_mouse_exited() -> void:
	ready_to_be_cut = false


func _on_cut_node_2_mouse_entered() -> void:
	ready_to_be_cut = true

func _on_cut_node_2_mouse_exited() -> void:
	ready_to_be_cut = false
