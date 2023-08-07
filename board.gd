extends Node2D

const COLUMNS = 10
const ROWS = 24
const STAGING = 4
const VISIBLE_ROWS = 20
const BLOCK_SIZE = 30
const GRID_WIDTH = 1
const START_X = 10
const START_Y = 0
const GRID_BG = "#000000"
const GRID_COLOUR = "#FFFFFF"

const GAP = 5
const NEXT_SHAPE_X = (COLUMNS * BLOCK_SIZE) + START_X + GAP
const NEXT_SHAPE_Y = START_Y + (BLOCK_SIZE * STAGING)

const FLASHES = 5
const FLASH_SPEED = 2
var FLASHING = false

# 0: pre-game, 1: play, 2: game over, 3: credits
var game_state = 0

var TETROMINO = {0: 'I', 1: 'J', 2: 'L',3: 'O',4: 'S',5: 'T',6: 'Z'}

var next_shape = randi() % 7
var current_shape = null

var shape
var shape_array = []

# GAME SPEED
var accel = 2
var speed = 20  # 50
var time = 0

# When a line is full, control the flashes
var flash_type = false
var flashes_done = 0
var lines = false

var board = [
		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
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
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
	]

# Called when the node enters the scene tree for the first time.
func _ready():
#	_spawn_shape(randi() % 7)
	pass


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
	queue_redraw()
	

	if FLASHING:
		time += speed * delta
		if time > FLASH_SPEED:
			time = 0
			_flash_lines(lines, flash_type)
			flash_type = !flash_type
			flashes_done += 1
			if flashes_done > FLASHES:
				flashes_done = 0
				FLASHING = false
				_wipe_lines(lines)
				_drop_lines(lines)
				
	
	if is_instance_valid(shape) and not FLASHING:  # check the shape has not been destroyed
		time += speed * delta
		if time > 10:
			time = 0
			shape.drop()
		_clear_board()
		_place_shape(shape, shape.is_set)
		lines = _check_for_line()
		if lines:
			FLASHING = true
	elif not FLASHING:
		current_shape = next_shape
		next_shape = randi() % 7
		_spawn_shape(current_shape)
#		_spawn_shape(0)
		print("Next Shape: " + str(TETROMINO[next_shape]))

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
			
func _drop_lines(rows):
	for row in rows:
		_move_all_down(row)
	
func _move_all_down(row):
	for i in range(row -1, -1, -1):
		for j in COLUMNS:
			board[i+1][j] = board[i][j]
			
func _blank_line(rows):
	for row in rows:
		for col in COLUMNS:
			board[row][col] = 0
			
func _unblank_line(rows):
	for row in rows:
		for col in COLUMNS:
			board[row][col] = 2
				
func _flash_lines(rows, flash_type):
	if flash_type == false:
		_blank_line(rows)
	if flash_type == true:
		_unblank_line(rows)

	
func _draw():
	#draw the outline of the board
	draw_rect( Rect2(START_X, START_Y + (BLOCK_SIZE * STAGING), COLUMNS * BLOCK_SIZE, VISIBLE_ROWS * BLOCK_SIZE), GRID_BG, GRID_WIDTH)
	# draw the column gridlines
	for i in range(START_X , BLOCK_SIZE * COLUMNS + START_X + 1, BLOCK_SIZE):
		draw_line( Vector2(i , START_Y + (BLOCK_SIZE * STAGING)), Vector2( i, ROWS * BLOCK_SIZE + START_Y), GRID_COLOUR, GRID_WIDTH)
	# draw the row gridlines
	for i in range(START_Y + (BLOCK_SIZE * STAGING), BLOCK_SIZE * ROWS + START_Y + 1, BLOCK_SIZE):
		draw_line( Vector2(START_X, i), Vector2(COLUMNS * BLOCK_SIZE + START_X, i ), GRID_COLOUR, GRID_WIDTH)
	
	# fill any squares in the board that != 0
	for i in range(STAGING, ROWS):
		for j in COLUMNS:
			if board[i][j] != 0:
				var rect = Rect2(j * BLOCK_SIZE + START_X, i * BLOCK_SIZE + START_Y, BLOCK_SIZE, BLOCK_SIZE)
				draw_rect(rect, GRID_COLOUR)
	
	# draw the next shape box
	draw_rect(Rect2(NEXT_SHAPE_X, NEXT_SHAPE_Y, 3 * BLOCK_SIZE, 5 * BLOCK_SIZE), GRID_BG, GRID_WIDTH)
	draw_rect(Rect2(NEXT_SHAPE_X, NEXT_SHAPE_Y, 3 * BLOCK_SIZE, 5 * BLOCK_SIZE), GRID_COLOUR, false, GRID_WIDTH)
	
	# draw the next shape in the box
	var _next_shape = _get_next_shape_matrix(next_shape)
	var _top_padding = BLOCK_SIZE
	var _left_padding = BLOCK_SIZE / 2
	if next_shape == 0:
		_top_padding = BLOCK_SIZE / 2
		_left_padding = BLOCK_SIZE
	
	for row in len(_next_shape):
		for col in len(_next_shape[0]):
			if _next_shape[row][col] == 1:
				draw_rect(Rect2(col * BLOCK_SIZE + NEXT_SHAPE_X + _left_padding, row * BLOCK_SIZE + NEXT_SHAPE_Y + _top_padding, BLOCK_SIZE, BLOCK_SIZE),GRID_COLOUR, GRID_WIDTH)
	
func _get_next_shape_matrix(next_shape):
	match (next_shape):
		0: return  [[1], # i
					[1],
					[1],
					[1],]
		1: return  [[0,1], # j
					[0,1],
					[1,1],]
		2: return  [[1,0], # l 
					[1,0],
					[1,1],] 
		3: return  [[1,1], # o
					[1,1],]
		4: return  [[1,0], # s
					[1,1],
					[0,1]]
		5: return  [[1,0], # t
					[1,1],
					[1,0]]
		6: return  [[0,1], # z
					[1,1],
					[1,0]]

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
				
func _set_up_new_shape(new_shape, pos):
	shape = new_shape.new()
	shape.shape_is_set.connect(_on_shape_shape_is_set)
	shape.my_board = board.duplicate()
	# amend the start y position if the shape is smaller than the 'i' piece
	shape.position = {'x': 4, "y": pos}

func _spawn_shape(num):
	match (num):
		0:
			var new_shape = preload("res://shape_i.gd")
			_set_up_new_shape(new_shape, 0)
		1:
			var new_shape = preload("res://shape_j.gd")
			_set_up_new_shape(new_shape, 1)
		2:
			var new_shape = preload("res://shape_l.gd")
			_set_up_new_shape(new_shape, 1)
		3:
			var new_shape = preload("res://shape_o.gd")
			_set_up_new_shape(new_shape, 2)
		4:
			var new_shape = preload("res://shape_s.gd")
			_set_up_new_shape(new_shape, 1)
		5:
			var new_shape = preload("res://shape_t.gd")
			_set_up_new_shape(new_shape, 1)
		6:
			var new_shape = preload("res://shape_z.gd")
			_set_up_new_shape(new_shape, 1)
			
	_place_shape(shape, shape.is_set)
	
func _place_shape(shape, value):
	shape.coords = []
	var start_x = shape.position.x
	var start_y = shape.position.y
	var num_cols = len(shape.frames[shape.frame_index][0])
	var num_rows = len(shape.frames[shape.frame_index])
	for i in range(start_y, start_y + num_rows):
		for j in range(start_x, start_x + num_cols):
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


func _on_shape_shape_is_set():
	_place_shape(shape, shape.is_set)
	if shape.position.y < 4:
		print("GAME OVER !!")
		game_state = 2

