extends Node
class_name Shape
const _ROWS = preload("res://board.gd").ROWS
var is_active = true

var position = {'x': 4, "y": 0}

# Called when the node enters the scene tree for the first time.
func _ready():
#	_ROWS = get_parent().get_node("board").ROWS  # FIXME not working
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func drop():
	if _check_if_can_drop() == true or is_active == true:
		position.y += 1


func _get_position():
	return position
	

func rotate(direction):
	var array = self.my_shape
	var transposed_array = [
	[0,0,0],
	[0,0,0],
	[0,0,0],
]
	var rotated_array = [
	[0,0,0],
	[0,0,0],
	[0,0,0],
]

	for row in len(array):
		for col in len(array[0]):
			transposed_array[row][col] = array[col][row]
			
	if direction == 1:
		for row in len(array):
			transposed_array[row].reverse()
		return transposed_array
	
	if direction == -1:
		for row in len(array):
			rotated_array[row] = transposed_array[len(transposed_array) - 1 - row]
		return rotated_array

func _check_collision():
	# if shape array has 1 and board below this has 1 
	# and is at end of move => is_active = false
	pass

func _check_if_can_drop():
	if position.y + _get_shape_height(self) < ( _ROWS):
		return true
	else:
		is_active = false
		return false

func _get_shape_height(shape):
	return len(shape.my_shape[0])
	

# 123
# 456

