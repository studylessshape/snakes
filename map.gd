extends Node

enum OutRangeRule {
	HOLD,
	CONSUMING,
	MOBIUS,
}

enum PutState {
	NONE,
	SUCCESS,
	CONSUMING,
}

class PutResult:
	var coordinate: Vector2i = Vector2i(-1, -1)
	var state: PutState = PutState.NONE

@export var map = []
var empty_space = []
var out_rule = OutRangeRule.MOBIUS
var width: int
var height: int
# trigger on before is not zero
signal replace_has_number(before, after, coordinate)

func initialize(w, h):
	width = w;
	height = h;
	for x in range(width):
		var row = []
		row.resize(height)
		row.fill(0)
		# save to mark array
		for y in row.size():
			empty_space.push_back(Vector2i(x, y))
		
		map.push_back(row)

# Put number and if success, the coordinate in empty_space will be removed
func put_number(x, y, number: int) -> PutResult:
	var put_res = PutResult.new()
	# out range check with rule
	if x < 0 or x >= width or y < 0 or y >= height:
		if out_rule == OutRangeRule.CONSUMING:
			put_res.state = PutState.CONSUMING
		if out_rule != OutRangeRule.MOBIUS:
			return put_res
		x = fposmod(x, width)
		y = fposmod(y, height)
		
	put_res.coordinate = Vector2i(x, y)
	
	if map[x][y] == 0:
		map[x][y] = number
	else:
		var before = map[x][y]
		map[x][y] = number;
		# signal trigger here
		replace_has_number.emit(before, number, Vector2i(x, y))
	
	var coordinate = Vector2i(x, y)
	var coordinate_index = empty_space.find(coordinate)
	if coordinate_index != -1 and number != 0:
		empty_space.remove_at(coordinate_index)
	elif number == 0:
		empty_space.push_back(coordinate)
	
	put_res.state = PutState.SUCCESS
	return put_res

# get one of empty place randly. This operation will not remove the coordinate
func rand_empty_place():
	return empty_space[randi_range(0, (empty_space.size() - 1))]
