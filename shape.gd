extends Node
class_name Shape
const _ROWS = preload("res://board.gd").ROWS
const _COLUMNS = preload("res://board.gd").COLUMNS
var COLOUR = randi() % 5
var my_board
var is_active = true
var is_set = 1  # 1 for active, 2 for set
signal shape_is_set

var position = {'x': 4, "y": 0}

var coords = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func drop():
	if _check_if_can_drop() == true and is_active == true:
		position.y += 1
	else:
		is_set = 2
		shape_is_set.emit()
		self.queue_free()
		
func move(direction):
	if _check_if_can_move(direction):
		var snapshot = _get_snapshop_of_board_where_shape_placed(direction, 0)
		for row in range(0, len(snapshot)):
			for col in range(0, len(snapshot[row])):
				if snapshot[row][col] + self.frames[self.frame_index][row][col] > 2:
					return 
		position.x += direction
	else:
		return



# returns an array of the part of the board where the shape would
# occupy if it moved there
func _get_snapshop_of_board_where_shape_placed(direction, rotation):
	var start_x = position.x + direction
	var start_y = position.y
	var num_cols = len(self.frames[self.frame_index + rotation][0])
	var num_rows = len(self.frames[self.frame_index + rotation])
	var board_snapshot = self.frames[self.frame_index + rotation].duplicate(true)
	for row in range(start_y, start_y + num_rows):
		for col in range(start_x, start_x + num_cols):
			board_snapshot[row - start_y][col - start_x] = my_board[row][col]['value']
	return board_snapshot

func _print_board():
	for row in _ROWS:
		print(my_board[row])
	print('--------------')
		
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
	if _check_if_can_rotate(direction):
		self.frame_index += direction
		self.frame_index %= len(self.frames)
	else: 
		return


func _check_if_can_drop():
#	if not _check_for_collision() and position.y + _get_shape_height() < _ROWS:
	if not _check_for_collision():
		return true
	else:
		is_active = false
		return false


func _check_for_collision():
	# return true if the shape will collide with something on the next drop
	for item in coords:
		# check if its at the end of the board
		if item.y + 1 >= _ROWS:
			return true
		if my_board[item.y + 1][item.x]['value'] == 2:
			return true
	return false
			
func _get_shape_height():
	return len(self.frames[self.frame_index])
	


func _check_if_can_rotate(direction):
	# returns false if the shape rotates and pushes it off the board
	var _frame_index = (self.frame_index + direction) % len(self.frames)
	var _frame_cols = len(self.frames[_frame_index][0])
	if (position.x + _frame_cols) > _COLUMNS:
		return false
	else:
		return true

