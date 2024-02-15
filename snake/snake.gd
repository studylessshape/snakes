class_name Snake extends Node2D

@export var snake_ceil_scene: PackedScene

var snake_ceils = []
var offset: float
var snake_number: float
var current_direction: Vector2
var is_dead = false

signal on_dead()

func initialize(ceil_coordinates, o: float, sn: int) -> void:
	offset = o
	snake_number = sn
	
	for coordinate in ceil_coordinates:
		var piece = snake_ceil_scene.instantiate()
		add_child(piece)
		piece.position = coordinate * offset
		snake_ceils.push_back(piece)
		
		Map.put_number(coordinate.x, coordinate.y, snake_number)

func move(direction: Vector2):
	if snake_ceils.is_empty():
		return
	if -direction.normalized() == current_direction:
		direction = current_direction
	current_direction = direction.normalized()
	
	var end_ceil = snake_ceils.pop_back()
	var end_position = end_ceil.position
	var head_position = snake_ceils.front().position
	
	head_position += direction * offset
	# set head number
	var head_coordinate = head_position / offset
	var put_res = Map.put_number(head_coordinate.x,head_coordinate.y, snake_number)
	if put_res.state == Map.PutState.NONE:
		snake_ceils.push_back(end_ceil)
		return
		
	# set before position to zero
	var end_coordinate = end_position / offset
	Map.put_number(end_coordinate.x, end_coordinate.y, 0)
	
	if put_res.state == Map.PutState.CONSUMING:
		end_ceil.free()
		return
	if put_res.state == Map.PutState.SUCCESS:
		head_position = put_res.coordinate * offset
	end_ceil.position = head_position
	
	snake_ceils.push_front(end_ceil)

func extend(length: int):
	var last_position = snake_ceils.back().position
	for c in length:
		var new_ceil = snake_ceil_scene.instantiate()
		add_child(new_ceil)
		new_ceil.position = last_position
		snake_ceils.push_back(new_ceil)
