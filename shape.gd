extends Node
class_name Shape
const _ROWS = preload("res://board.gd").ROWS
var board
var is_active = true
var is_set = 1  # 1 for active, 2 for set
signal shape_is_set

var position = {'x': 4, "y": 0}

var coords = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	_board = get_node("/root/main/board").board
#	print(_board)
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
		
func move(direction):
	if _check_if_can_move(direction):
		if direction == 1:
			position.x += 1
		if direction == -1:
			position.x -= 1
	else:
		return
		
func _check_if_can_move(direction):
	if position.x + direction >= 0 and position.x + direction <= (10 - len(self.frames[self.frame_index][0])):
		return true
	else:
		return false

func _get_position():
	return position

# used for debugging
func _print_array(arr):
	print("Length: " + str(len(arr)))
	for row in len(arr):
		print("Row: " + str(row) + " " + str(arr[row]))

func rotate(direction):
	if direction == 1:
		self.frame_index += 1
		self.frame_index = self.frame_index % len(self.frames)
		return self.frames[self.frame_index]
	if direction == -1:
		self.frame_index -= 1
		self.frame_index = self.frame_index % len(self.frames)
		return self.frames[self.frame_index]


func _check_if_can_drop2():
	if position.y + _get_shape_height(self) < ( _ROWS):
		return true
	else:
		is_active = false
		return false
		

func _check_if_can_drop():
	if _check_for_collision() and position.y + _get_shape_height(self) < ( _ROWS):
		return true
	else:
		is_active = false
		return false

func _check_for_collision():
	for item in coords:
		if item.y + 1 > 19:
			return false
		if board[item.y + 1][item.x] == 2:
			return false
		else:
			return true
			
func _get_shape_height(shape):
	return len(self.frames[self.frame_index])
	

