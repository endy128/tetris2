extends Node
class_name Shape
const _ROWS = preload("res://board.gd").ROWS
var is_active = true
var is_set = 1  # 1 for active, 2 for set
signal shape_is_set

var position = {'x': 4, "y": 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func drop():
	if _check_if_can_drop() == true or is_active == true:
		position.y += 1
	else:
		print("Destroying shape")
		is_set = 2
		shape_is_set.emit()
		self.queue_free()
		


func _get_position():
	return position

# used for debugging
func _print_array(arr):
	print("Length: " + str(len(arr)))
	for row in len(arr):
		print("Row: " + str(row) + " " + str(arr[row]))

func rotate(direction):
	if direction == 1:
		self.cell_index += 1
		self.cell_index = self.cell_index % len(self.cells)
		return self.cells[self.cell_index]
	if direction == -1:
		self.cell_index -= 1
		self.cell_index = self.cell_index % len(self.cells)
		return self.cells[self.cell_index]
#	var array = self.my_shape
#	var transposed_array = self.my_shape_blank.duplicate(true)
#	var rotated_array = self.my_shape_blank.duplicate(true)
#
#
#	for row in len(array):
#		for col in len(array[0]):
#			transposed_array[row][col] = array[col][row]
#
#	if direction == 1:
#		for row in len(transposed_array):
#			transposed_array[row].reverse()
#		return transposed_array
#
#	if direction == -1:
#		for row in len(transposed_array):
#			rotated_array[row] = transposed_array[len(transposed_array) - 1 - row]
#		return rotated_array

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
	return len(self.cells[self.cell_index])
	

