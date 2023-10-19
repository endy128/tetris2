extends Node2D

const DEBUG = 0

var SHAPE_COLOURS = {
	0: Color.html('#004d99'),
	1: Color.html('#4d0099'), 
	2: Color.html('#994d00'), 
	3: Color.html('#4d9900'),
	4: Color.html('#99004d'),
}


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

const SQUARE_OUTLINE = "#ffffff"
const SQUARE_BG = "#808080"
const SQUARE_FG = "#d9d9d9"

const GAP = 5
const NEXT_SHAPE_X = (COLUMNS * BLOCK_SIZE) + START_X + GAP
const NEXT_SHAPE_Y = START_Y + (BLOCK_SIZE * STAGING)

const SCORE_BOX_X = (COLUMNS * BLOCK_SIZE) + START_X + GAP
const SCORE_BOX_Y = START_Y + (BLOCK_SIZE * STAGING) + GAP + (5 * BLOCK_SIZE)

const FLASHES = 5
const FLASH_SPEED = 1
var is_flashing = false

# points for placing shape and clearing a line & tetris
var score = 0
const SCORE_PLACE = 10
const SCORE_LINE = 100
const SCORE_BONUS = 500

var level = 0
const LEVEL_INCREASE = 10
const LEVEL_MAX = 200
const LEVEL_ROLLOVER = 100


# 0: pre-game, 1: play, 2: game over, 3: credits
var game_state = 0

var TETROMINO = {0: 'I', 1: 'J', 2: 'L',3: 'O',4: 'S',5: 'T',6: 'Z'}

var next_shape = randi() % 7
var next_shape_colour = randi() % len(SHAPE_COLOURS)
var current_shape = null
var current_shape_colour = null


var shape
var shape_array = []

# GAME SPEED
#var accel = 0.0005 # not needed ad levels increase the speed
var speed = 10  # 50
var time = 0
var btn_repeat_time = 0
const BTN_REPEAT_DELAY = -5
const BTN_REPEAT_THRESHOLD = 0.25

# When a line is full, control the flashes
var flash_type = false
var flashes_done = 0
var lines = false

var default_font = ThemeDB.fallback_font
var default_font_size = ThemeDB.fallback_font_size

var movement = 0

var board = []
#var board = [
#		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
#		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
#		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
#		[0,0,0,0,0,0,0,0,0,0], # staginng, not drawn
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#		[0,0,0,0,0,0,0,0,0,0],
#	]
	


# Called when the node enters the scene tree for the first time.
func _ready():
#	_spawn_shape(randi() % 7)
	# set up empty board, 1st four rows are NOT rendered
	for row in range(ROWS):
		board.append([])
		for col in range(COLUMNS):
			board[row].append([])
			board[row][col] = {'value': 0, 'colour': 0}

func _level_up():
	print("LEVEL UP!!")

func _input(event):
	# ensure the shape is instanciated before we try and move it
	if is_instance_valid(shape):
		if event.is_action_pressed("rotate_l"):
			shape.rotate(1)
		if event.is_action_pressed("rotate_r"):
			shape.rotate(-1)
		if event.is_action_pressed("right"):
			btn_repeat_time = BTN_REPEAT_DELAY
			shape.move(1)
			movement = 1
		if event.is_action_pressed("left"):
			btn_repeat_time = BTN_REPEAT_DELAY
			shape.move(-1)
			movement = -1
		if event.is_action_pressed("down"):
			time = 1000
	if event.is_action_released("down"):
		time = 0
	if event.is_action_released("left"):
		movement = 0
		btn_repeat_time = 0
	if event.is_action_released("right"):
		movement = 0
		btn_repeat_time = 0
		

func _check_level_up():
	if score >= (level * 1000):
		_level_up()
		level += 1
		if score > 20000:
			speed += LEVEL_INCREASE
		else:
			speed += LEVEL_INCREASE / 2
		if speed > LEVEL_MAX:
			speed = LEVEL_ROLLOVER
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if game_state == 0:
	# draw title screen with start button
		return
	
	if game_state == 2:
	# GAME OVER
		return
		
	queue_redraw()
	
	_check_level_up()
	
	
	if is_flashing:
		time += speed * delta
		if time > FLASH_SPEED:
			time = 0
			_flash_lines(lines, flash_type)
			flash_type = !flash_type
			flashes_done += 1
			if flashes_done > FLASHES:
				flashes_done = 0
				is_flashing = false
				_wipe_lines(lines)
				_drop_lines(lines)
				_add_score(len(lines), SCORE_LINE)
				
	
	if is_instance_valid(shape) and not is_flashing:  # check the shape has not been destroyed
		
		# repeat movement if button is being held
		btn_repeat_time += 10 * delta
		if movement != 0 and btn_repeat_time > BTN_REPEAT_THRESHOLD:
			shape.move(movement)
			btn_repeat_time = 0
			

			
		time += speed * delta
		if time > 10:
			if time < 1000:
				time = 0
			shape.drop()
		_clear_board()
		_place_shape(shape, shape.is_set)
		lines = _check_for_line()
		if lines:
			is_flashing = true
	elif not is_flashing:
		current_shape = next_shape
		current_shape_colour = next_shape_colour
		next_shape = randi() % 7
		next_shape_colour = randi() % len(SHAPE_COLOURS)
		_spawn_shape(current_shape, current_shape_colour)
#		_spawn_shape(0)
		print("Next Shape: " + str(TETROMINO[next_shape]))

func _add_score(points, type):
	if (points == 4):
		score += SCORE_BONUS
		print("BONUS: " + str(SCORE_BONUS))
	score += points * type
	print("SCORE: " + str(score))

		
func _check_for_line():
	var lines_to_wipe = []
	for row in ROWS:
		for col in COLUMNS:
			if board[row][col]['value'] == 2:
				if col == COLUMNS - 1:
					lines_to_wipe.push_back(row)
			else: 
				break
	if lines_to_wipe.is_empty():
		return false
	else:
		return lines_to_wipe
		
func _wipe_lines(rows):
	for row in rows:
		for col in COLUMNS:
			board[row][col]['value'] = 0
			
func _drop_lines(rows):
	for row in rows:
		_move_all_down(row)
	
func _move_all_down(move_row):
	for row in range(move_row -1, -1, -1):
		for col in COLUMNS:
			board[row+1][col]['value'] = board[row][col]['value']
			board[row+1][col]['colour'] = board[row][col]['colour']
			
func _blank_line(rows):
	for row in rows:
		for col in COLUMNS:
			board[row][col]['value'] = 0
			
func _unblank_line(rows):
	for row in rows:
		for col in COLUMNS:
			board[row][col]['value'] = 2
				
func _flash_lines(rows, flash_type):
	if flash_type == false:
		_blank_line(rows)
	if flash_type == true:
		_unblank_line(rows)

	
func _draw():
	
	
	if game_state == 0:
		# draw title screen with start button
		pass
		
	# game begins
	if game_state == 1 or game_state == 2: # draw the board at game over
		#draw the outline of the board
		draw_rect( Rect2(START_X, START_Y + (BLOCK_SIZE * STAGING), COLUMNS * BLOCK_SIZE, VISIBLE_ROWS * BLOCK_SIZE), GRID_BG, GRID_WIDTH)
		draw_rect( Rect2(START_X, START_Y + (BLOCK_SIZE * STAGING), COLUMNS * BLOCK_SIZE, VISIBLE_ROWS * BLOCK_SIZE), GRID_COLOUR, false, GRID_WIDTH)
		
		if DEBUG:
			# draw the column gridlines
			for i in range(START_X , BLOCK_SIZE * COLUMNS + START_X + 1, BLOCK_SIZE):
				draw_line( Vector2(i , START_Y + (BLOCK_SIZE * STAGING)), Vector2( i, ROWS * BLOCK_SIZE + START_Y), GRID_COLOUR, GRID_WIDTH)
			# draw the row gridlines
			for i in range(START_Y + (BLOCK_SIZE * STAGING), BLOCK_SIZE * ROWS + START_Y + 1, BLOCK_SIZE):
				draw_line( Vector2(START_X, i), Vector2(COLUMNS * BLOCK_SIZE + START_X, i ), GRID_COLOUR, GRID_WIDTH)
		
		const border_width = 1
		const step_down = 4
		const step_down_2 = step_down * 2
		const step_down_3 = step_down_2 * 2
			
		# fill any squares in the board that != 0
		for row in range(STAGING, ROWS):
			for col in COLUMNS:
				if board[row][col]['value'] != 0:
					var _colour = SHAPE_COLOURS[board[row][col]['colour']]
					var x = col * BLOCK_SIZE + START_X
					var y = row * BLOCK_SIZE + START_Y
					var width = BLOCK_SIZE
					var height = BLOCK_SIZE
				
					var rect_0 = Rect2(x, y, width, height)
					var rect_1 = Rect2(x, y, width - border_width, height - border_width)
					var rect_2 = Rect2(x + step_down, y + step_down, width - (step_down * 2) - border_width, height - (step_down * 2) - border_width)
					var rect_3 = Rect2(x + step_down_2, y + step_down_2, width - (step_down_2 * 2) - border_width, height - (step_down_2 * 2) - border_width)
					var rect_4 = Rect2(x + step_down_3, y + step_down_3, width - (step_down_3 * 2) - border_width, height - (step_down_3 * 2) - border_width)
					draw_rect(rect_0, _colour.lightened(0.4), false, 1)
					draw_rect(rect_1, _colour.darkened(0.2)) # darker
					draw_rect(rect_2, _colour.lightened(0.2)) # darker
					draw_rect(rect_3, _colour.darkened(0.2)) # darker
					draw_rect(rect_4, _colour.lightened(0.2)) # darker
					
					
		
		# draw the next shape box
		draw_rect(Rect2(NEXT_SHAPE_X, NEXT_SHAPE_Y, 3 * BLOCK_SIZE, 5 * BLOCK_SIZE), GRID_BG, GRID_WIDTH)
		draw_rect(Rect2(NEXT_SHAPE_X, NEXT_SHAPE_Y, 3 * BLOCK_SIZE, 5 * BLOCK_SIZE), GRID_COLOUR, false, GRID_WIDTH)
		
		# draw the score box
		draw_rect(Rect2(SCORE_BOX_X, SCORE_BOX_Y, 3 * BLOCK_SIZE, 3 * BLOCK_SIZE), GRID_BG, GRID_WIDTH)
		draw_rect(Rect2(SCORE_BOX_X, SCORE_BOX_Y, 3 * BLOCK_SIZE, 3 * BLOCK_SIZE), GRID_COLOUR, false, GRID_WIDTH)
		
		# draw the level text
		draw_string(default_font, Vector2(SCORE_BOX_X + 5, SCORE_BOX_Y + 20), "LEVEL:", HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
		draw_string(default_font, Vector2(SCORE_BOX_X + (1.5 * BLOCK_SIZE), SCORE_BOX_Y + 40), str(level), HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
		
		# draw the Score text
		draw_string(default_font, Vector2(SCORE_BOX_X + 5, SCORE_BOX_Y + 60), "SCORE:", HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
		draw_string(default_font, Vector2(SCORE_BOX_X + 5, SCORE_BOX_Y + 80), "%010d" % score, HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
		
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
					var _colour = SHAPE_COLOURS[next_shape_colour]
					var x = col * BLOCK_SIZE + NEXT_SHAPE_X + _left_padding
					var y = row * BLOCK_SIZE + NEXT_SHAPE_Y + _top_padding
					var width = BLOCK_SIZE
					var height = BLOCK_SIZE
					var rect_0 = Rect2(x, y, width, height)
					var rect_1 = Rect2(x, y, width - border_width, height - border_width)
					var rect_2 = Rect2(x + step_down, y + step_down, width - (step_down * 2) - border_width, height - (step_down * 2) - border_width)
					var rect_3 = Rect2(x + step_down_2, y + step_down_2, width - (step_down_2 * 2) - border_width, height - (step_down_2 * 2) - border_width)
					var rect_4 = Rect2(x + step_down_3, y + step_down_3, width - (step_down_3 * 2) - border_width, height - (step_down_3 * 2) - border_width)
					draw_rect(rect_0, _colour.lightened(0.4), false, 1)
					draw_rect(rect_1, _colour.darkened(0.2)) # darker
					draw_rect(rect_2, _colour.lightened(0.2)) # lighter
					draw_rect(rect_3, _colour.darkened(0.2)) # darker
					draw_rect(rect_4, _colour.lightened(0.2)) # lighter
					
	
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
	for row in ROWS:
		print(board[row])
	print('--------------')


func _clear_board():
	for row in ROWS:
		for col in COLUMNS:
			if board[row][col]['value'] == 2:
				pass
			else:
				board[row][col]['value'] = 0
				
func _set_up_new_shape(new_shape, pos, colour):
	shape = new_shape.new()
	shape.shape_is_set.connect(_on_shape_shape_is_set)
	shape.my_board = board.duplicate()
	# amend the start y position if the shape is smaller than the 'i' piece
	shape.position = {'x': 4, "y": pos}
	shape.COLOUR = colour

func _spawn_shape(num, colour):
	match (num):
		0:
			var new_shape = preload("res://shape_i.gd")
			_set_up_new_shape(new_shape, 0, colour)
		1:
			var new_shape = preload("res://shape_j.gd")
			_set_up_new_shape(new_shape, 1, colour)
		2:
			var new_shape = preload("res://shape_l.gd")
			_set_up_new_shape(new_shape, 1, colour)
		3:
			var new_shape = preload("res://shape_o.gd")
			_set_up_new_shape(new_shape, 2, colour)
		4:
			var new_shape = preload("res://shape_s.gd")
			_set_up_new_shape(new_shape, 1, colour)
		5:
			var new_shape = preload("res://shape_t.gd")
			_set_up_new_shape(new_shape, 1, colour)
		6:
			var new_shape = preload("res://shape_z.gd")
			_set_up_new_shape(new_shape, 1, colour)
			
	_place_shape(shape, shape.is_set)
	
func _place_shape(shape, value):
	shape.coords = []
	var start_x = shape.position.x
	var start_y = shape.position.y
	var num_cols = len(shape.frames[shape.frame_index][0])
	var num_rows = len(shape.frames[shape.frame_index])
	for row in range(start_y, start_y + num_rows):
		for col in range(start_x, start_x + num_cols):
			# add all current shape coords to an array for checking on collision
			_set_shape_last_row_coords(shape, row, col, start_y, start_x)
			if value == 2:
				if shape.frames[shape.frame_index][row - start_y][col - start_x] == 1 or board[row][col]['value'] == 2:
					board[row][col]['value'] = 2
				else: 
					board[row][col]['value'] = 0
			else:
				if board[row][col]['value'] == 2:
					pass
				else:
					board[row][col]['value'] = shape.frames[shape.frame_index][row - start_y][col - start_x]
					board[row][col]['colour'] = shape.COLOUR

# sets an array with all the coords of the shape's last row
# use this to calc if it hits another block, ie to build the wall
func _set_shape_last_row_coords(shape, row, col, start_y, start_x):
	if shape.frames[shape.frame_index][row - start_y][col - start_x] == 1:
		shape.coords.push_back({'x': col, 'y': row})


func _on_shape_shape_is_set():
	_place_shape(shape, shape.is_set)
	_add_score(1, SCORE_PLACE)
	if shape.position.y < 4:
		print("GAME OVER !!")
		game_state = 2
	if DEBUG:
		_print_board()


func _on_touch_screen_button_pressed():
	get_node("../controls/start_button").hide()
	game_state = 1
