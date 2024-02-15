extends MeshInstance2D

var place_coordinate: Vector2i = Vector2i(-1, -1)

signal eated()

func _ready():
	Map.replace_has_number.connect(is_eated)
	pass

func is_eated(_before, _after, coordinate):
	if place_coordinate != coordinate:
		return
	eated.emit()
