extends Node
class_name Shape
const _ROWS = preload("res://board.gd").ROWS
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
		print("Destroying shape")
		print(Time.get_ticks_msec())
		is_set = 2
		shape_is_set.emit()
		self.queue_free()
		
func move(direction):
	if _check_if_can_move(direction):
		for lines in _get_board_of_shape_placement(direction):
			if lines.find(2) == 0:
				return
		position.x += direction
	else:
		return

	
func _get_board_of_shape_placement(direction):
	var start_x = position.x + direction
	var start_y = position.y
	var num_cols = len(self.frames[self.frame_index][0])
	var num_rows = len(self.frames[self.frame_index])
	var board_snapshot = self.frames[self.frame_index].duplicate(true)
	for i in range(start_y, start_y + num_rows):
		for j in range(start_x, start_x + num_cols):
			board_snapshot[i - start_y][j - start_x] = my_board[i][j]
	return board_snapshot

func _print_board():
	for i in _ROWS:
		print(my_board[i])
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
	if direction == 1:
		self.frame_index += 1
		self.frame_index = self.frame_index % len(self.frames)
		return self.frames[self.frame_index]
	if direction == -1:
		self.frame_index -= 1
		self.frame_index = self.frame_index % len(self.frames)
		return self.frames[self.frame_index]


#func _check_if_can_drop2():
#	if position.y + _get_shape_height(self) < ( _ROWS):
#		return true
#	else:
#		is_active = false
#		return false
		

func _check_if_can_drop():
	if not _check_for_collision() and position.y + _get_shape_height() < ( _ROWS):
		return true
	else:
		is_active = false
		return false


func _check_for_collision():
	for item in coords:
		if item.y + 1 > 19:
			return true
		if my_board[item.y + 1][item.x] == 2:
			return true
		else:
			
			return false
			
func _get_shape_height():
	return len(self.frames[self.frame_index])
	

