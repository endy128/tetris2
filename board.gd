extends Node2D

const COLUMNS = 10
const ROWS = 20
const BLOCK_SIZE = 30
const GRID_WIDTH = 1
const START_X = 25
const START_Y = 130
const GRID_BG = "#000000"
const GRID_COLOUR = "#FFFFFF"


var shape

var shape_array = []

var accel = 2
var speed = 20  # 50
var time = 0

var board = [
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[2,2,2,2,2,2,2,0,2,2],
		[2,2,2,2,2,2,2,0,2,2],
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_shape(randi() % 7)


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE or event.keycode == KEY_UP:
			shape.rotate(1)
		if event.keycode == KEY_ALT:
			shape.rotate(-1)
		if event.keycode == KEY_RIGHT:
			shape.move(1)
		if event.keycode == KEY_LEFT:
			shape.move(-1)
		if event.keycode == KEY_DOWN:
			time = 1000
		if event.is_action_released("down"):
			time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(shape):  # check the shape has not been destroyed
		time += speed * delta
		if time > 10:
			time = 0
			shape.drop()
		_clear_board()
		_place_shape(shape, shape.is_set)
		queue_redraw()
		var lines = _check_for_line()
		if lines:
			_wipe_lines(lines)
			_drop_lines(lines)
	else:
		_spawn_shape(randi() % 7)
#		_spawn_shape(0)

func _check_for_line():
	var lines_to_wipe = []
	for i in ROWS:
		for j in COLUMNS:
			if board[i][j] == 2:
				if j == COLUMNS - 1:
					lines_to_wipe.push_back(i)
			else: 
				break
	if lines_to_wipe.is_empty():
		return false
	else:
		return lines_to_wipe
		
func _wipe_lines(rows):
	for row in rows:
		for col in COLUMNS:
			board[row][col] = 0
			
func _drop_lines(lines):
	for line in lines:
		_move_all_down(line)
	
func _move_all_down(row):
	for i in range(row -1, -1, -1):  ## may need to be row-1
		print(i)
		for j in COLUMNS:
			board[i+1][j] = board[i][j]
				
	
func _draw():
	#draw the outline of the board
	draw_rect( Rect2(START_X, START_Y, COLUMNS * BLOCK_SIZE, ROWS * BLOCK_SIZE), GRID_BG, GRID_WIDTH)
	# draw the column gridlines
	for i in range(START_X, BLOCK_SIZE * COLUMNS + START_X + 1, BLOCK_SIZE):
		draw_line( Vector2(i , START_Y), Vector2( i, ROWS * BLOCK_SIZE + START_Y), GRID_COLOUR, GRID_WIDTH)
	# draw the row gridlines
	for i in range(START_Y, BLOCK_SIZE * ROWS + START_Y + 1, BLOCK_SIZE):
		draw_line(Vector2(START_X, i), Vector2(COLUMNS * BLOCK_SIZE + START_X, i ), GRID_COLOUR, GRID_WIDTH)
	# fill the squares in
	for i in ROWS:
		for j in COLUMNS:
			if board[i][j] != 0:
				var rect = Rect2(j * BLOCK_SIZE + START_X, i * BLOCK_SIZE + START_Y, BLOCK_SIZE, BLOCK_SIZE)
				draw_rect(rect, GRID_COLOUR)
	
	


func _print_board():
	for i in ROWS:
		print(board[i])
	print('--------------')


func _set_square(x , y):
	board[y][x] = 1


func _clear_board():
	for i in ROWS:
		for j in COLUMNS:
			if board[i][j] == 2:
				pass
			else:
				board[i][j] = 0
				
func _set_up_new_shape(new_shape):
	shape = new_shape.new()
	shape.shape_is_set.connect(_on_shape_shape_is_set)
	shape.my_board = board.duplicate()

func _spawn_shape(num):
	match (num):
		0:
			var new_shape = preload("res://shape_i.gd")
			_set_up_new_shape(new_shape)
		1:
			var new_shape = preload("res://shape_j.gd")
			_set_up_new_shape(new_shape)
		2:
			var new_shape = preload("res://shape_l.gd")
			_set_up_new_shape(new_shape)
		3:
			var new_shape = preload("res://shape_o.gd")
			_set_up_new_shape(new_shape)
		4:
			var new_shape = preload("res://shape_s.gd")
			_set_up_new_shape(new_shape)
		5:
			var new_shape = preload("res://shape_t.gd")
			_set_up_new_shape(new_shape)
		6:
			var new_shape = preload("res://shape_z.gd")
			_set_up_new_shape(new_shape)
			
	_place_shape(shape, shape.is_set)
	
func _place_shape(shape, value):
	shape.coords = []
	var start_x = shape.position.x
	var start_y = shape.position.y
	var num_cols = len(shape.frames[shape.frame_index][0])
	var num_rows = len(shape.frames[shape.frame_index])
	_reset_coords(shape)
	for i in range(start_y, start_y + num_rows):
		for j in range(start_x, start_x + num_cols):
			# when the last row of the shape is being placed
			# set the co-ords of the filled squares
#			if i == start_y + num_rows - 1:

			# add all current shape coords to an array for checking on collision
			_set_shape_last_row_coords(shape, i, j, start_y, start_x)
			if value == 2:
				if shape.frames[shape.frame_index][i - start_y][j - start_x] == 1 or board[i][j] == 2:
					board[i][j] = 2
				else: 
					board[i][j] = 0
			else:
				if board[i][j] == 2:
					pass
				else:
					board[i][j] = shape.frames[shape.frame_index][i - start_y][j - start_x]

# sets an array with all the coords of the shape's last row
# use this to calc if it hits another block, ie to build the wall
func _set_shape_last_row_coords(shape, i, j, start_y, start_x):
	if shape.frames[shape.frame_index][i - start_y][j - start_x] == 1:
		shape.coords.push_back({'x': j, 'y': i})

func _reset_coords(shape):
	shape.coords = []
	return
	

func _on_shape_shape_is_set():
	_place_shape(shape, shape.is_set)
#	_print_board()
