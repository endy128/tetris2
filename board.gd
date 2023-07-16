extends Node2D

const COLUMNS = 10
const ROWS = 20
const BLOCK_SIZE = 30
const GRID_WIDTH = 1
const START_X = 25
const START_Y = 130
const GRID_BG = "#000000"
const GRID_COLOUR = "#FFFFFF"

var shape_i
var shape_j
var shape_l
var shape_o
var shape_s
var shape_t
var shape_z
var shape

var shape_array = [
	
]

var accel = 2
var speed = 50
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
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(shape):  # check the shape has not been destroyed
		time += speed * delta
		if time > 10:
			time = 0
			shape.drop()
			_clear_board()
			_place_shape(shape, shape.is_set)
			_render_board()
			queue_redraw()
			return
		_clear_board()
		_place_shape(shape, shape.is_set)
		_render_board()
		queue_redraw()
	else:
		_spawn_shape(randi() % 7)
#		_spawn_shape(1)


	
func _draw():
	draw_rect( Rect2(START_X, START_Y, COLUMNS * BLOCK_SIZE, ROWS * BLOCK_SIZE), GRID_BG, true, GRID_WIDTH)
	# draw the column gridlines
	for i in range(START_X, BLOCK_SIZE * COLUMNS + START_X + 1, BLOCK_SIZE):
		draw_line( Vector2(i , START_Y), Vector2( i, ROWS * BLOCK_SIZE + START_Y), GRID_COLOUR, GRID_WIDTH)
	
	# draw the row gridlines
	for i in range(START_Y, BLOCK_SIZE * ROWS + START_Y + 1, BLOCK_SIZE):
		draw_line(Vector2(START_X, i), Vector2(COLUMNS * BLOCK_SIZE + START_X, i ), GRID_COLOUR, GRID_WIDTH)
	
#	_place_shape(shape)
	_render_board()



func _fill_square( x, y ):
	var rect = Rect2(x * BLOCK_SIZE + START_X, y * BLOCK_SIZE + START_Y, BLOCK_SIZE, BLOCK_SIZE)
	draw_rect(rect, GRID_COLOUR)
	
func _print_board():
	for i in ROWS:
		print(board[i])
	print('--------------')


func _set_square(x , y):
	board[y][x] = 1


func _render_board():
	for i in ROWS:
		for j in COLUMNS:
			if board[i][j] != 0:
				_fill_square(j,i)
	queue_redraw()


func _clear_board():
	for i in ROWS:
		for j in COLUMNS:
			if board[i][j] == 2:
				pass
			else:
				board[i][j] = 0

func _spawn_shape(num):
	match (num):
		0:
			shape_i = preload("res://shape_i.gd")
			shape = shape_i.new()
			shape.shape_is_set.connect(_on_shape_shape_is_set)
		1:
			shape_j = preload("res://shape_j.gd")
			shape = shape_j.new()
			shape.shape_is_set.connect(_on_shape_shape_is_set)

		2:
			shape_l = preload("res://shape_l.gd")
			shape = shape_l.new()
			shape.shape_is_set.connect(_on_shape_shape_is_set)

		3:
			shape_o = preload("res://shape_o.gd")
			shape = shape_o.new()
			shape.shape_is_set.connect(_on_shape_shape_is_set)

		4:
			shape_s = preload("res://shape_s.gd")
			shape = shape_s.new()
			shape.shape_is_set.connect(_on_shape_shape_is_set)

		5:
			shape_t = preload("res://shape_t.gd")
			shape = shape_t.new()
			shape.shape_is_set.connect(_on_shape_shape_is_set)

		6:
			shape_z = preload("res://shape_z.gd")
			shape = shape_z.new()
			shape.shape_is_set.connect(_on_shape_shape_is_set)
			
	_place_shape(shape, 1)
	
func _place_shape(shape, value):
	var start_x = shape.position.x
	var start_y = shape.position.y
	var num_cols = len(shape.frames[shape.frame_index][0])
	var num_rows = len(shape.frames[shape.frame_index])
	for i in range(start_y, start_y + num_rows):
		for j in range(start_x, start_x + num_cols):
			if value == 2:
				if shape.frames[shape.frame_index][i - start_y][j - start_x] == 1:
					board[i][j] = 2
				else: 
					board[i][j] = 0
			else:
				board[i][j] = shape.frames[shape.frame_index][i - start_y][j - start_x]



func _on_shape_shape_is_set():
	_place_shape(shape, 2)
	_print_board()
