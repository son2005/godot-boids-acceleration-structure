extends Node

var _cells: Array
var _scale: int
var _map: Dictionary = {}

var x_min: int
var x_max: int
var y_min: int
var y_max: int

func _init(bounds: Rect2, scale: int):
	_scale = scale

	x_min = _scale_axis(bounds.position.x)
	x_max = _scale_axis(bounds.end.x)
	y_min = _scale_axis(bounds.position.y)
	y_max = _scale_axis(bounds.end.y)
	
	_cells = range(x_min, x_max + 1)
	
	for x in range(_cells.size()):
		_cells[x] = range(y_min, y_max + 1)
		for y in _cells[x].size():
			_cells[x][y] = []


func _scale_axis(point: float) -> int:
	return int(floor(point / _scale))


func scale_point(vector: Vector2) -> Vector2:
	return(vector / _scale).floor()


func add_body(body: Node2D, scaled_point: Vector2) -> void:
	_cells[scaled_point.x][scaled_point.y].append(body)


func remove_body(body: Node2D, scaled_point: Vector2) -> void:
	var loc: int = _cells[scaled_point.x][scaled_point.y].find(body)
	_cells[scaled_point.x][scaled_point.y].remove(loc)


func update_body(body: Node2D, scaled_point: Vector2, prev_point: Vector2) -> Vector2:	
	
	if prev_point.x != scaled_point.x or prev_point.y != scaled_point.y:
		remove_body(body, prev_point)
		add_body(body, scaled_point)
		return scaled_point
	else:
		return prev_point


func get_bodies(body: Node2D, scaled_point: Vector2):
	var x = scaled_point.x
	var y = scaled_point.y
	
	var bodies = _cells[x][y]
	if x - 1 >= x_min:
		bodies += _cells[x - 1][y]
	if x + 1 <= x_max:
		bodies += _cells[x + 1][y]
	if y - 1 >= y_min:
		bodies += _cells[x][y - 1]
	if y + 1 <= y_max:
		bodies += _cells[x][y + 1]
	
	return bodies