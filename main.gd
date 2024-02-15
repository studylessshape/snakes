extends Node

@export var width = 20
@export var height = 20
@export var offset = 20.0

@export var snake: PackedScene
#@export var food_scene: PackedScene
var snake_node: Node

enum MapNumbers {
	NONE = 0,
	SNAKE = 1,
	FOOD = 2,
}

var snake_direction = Vector2i.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	Map.initialize(width, height)
	# Generate and initialize snake
	snake_node = snake.instantiate()
	add_child(snake_node)
	
	snake_node.initialize([Vector2i(5,3), Vector2i(5,4), Vector2i(5,5)], offset, MapNumbers.SNAKE as int)
	place_food()

# snake move
func _on_timer_timeout():
	snake_node.move(snake_direction)

func _process(delta):
	if Input.is_action_pressed("move_up"):
		snake_direction = Vector2i.UP
	if Input.is_action_pressed("move_down"):
		snake_direction = Vector2i.DOWN
	if Input.is_action_pressed("move_left"):
		snake_direction = Vector2i.LEFT
	if Input.is_action_pressed("move_right"):
		snake_direction = Vector2i.RIGHT

func place_food():
	var rand_index = randi_range(0, Map.empty_space.size() - 1)
	var place = Map.empty_space[rand_index]
	Map.put_number(place.x, place.y, MapNumbers.FOOD)
	
	#var food_node = food_scene.instantiate()
	#add_child(food_node)
	$Food.position = place * offset
	$Food.place_coordinate = place


func _on_food_eated():
	snake_node.extend(1)
	place_food()
