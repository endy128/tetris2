extends Node2D

const COLUMNS = 10
const ROWS = 20
const BLOCK_SIZE = 30
const GRID_WIDTH = 1
const START_X = 25
const START_Y = 130
const GRID_BG = "#000000"
const GRID_COLOUR = "#FFFFFF"

#var shape_l = preload("res://shape_l.gd")
var shape_l
#var shape = shape_l.new()
var shape

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
#	_set_square(0,0)
#	_set_square(2,5)
#	_set_square(9,19)
#	_set_square(5,2)
#	_set_square(1,2)
	shape_l = preload("res://shape_l.gd")
	shape = shape_l.new()
	_place_shape(shape)
	
#	_print_board()
	

	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_LEFT:
			shape.my_shape = shape.rotate(1)
		if event.keycode == KEY_RIGHT:
			shape.my_shape = shape.rotate(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += speed * delta
	if time > 10:
		time = 0
		shape.drop()
		_clear_board()
		_place_shape(shape)
#		_print_board()
		_render_board()
		queue_redraw()
		return
	_clear_board()
	_place_shape(shape)
#	_print_board()
	_render_board()
	queue_redraw()
#	print(shape.position)


	
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
			if board[i][j] == 1:
				_fill_square(j,i)
	queue_redraw()


func _clear_board():
	for i in ROWS:
		for j in COLUMNS:
			board[i][j] = 0	

func _spawn_shape():
	pass
	
func _place_shape(shape):
	var start_x = shape.position.x
	var start_y = shape.position.y
	var num_cols = len(shape.my_shape[0])
	var num_rows = len(shape.my_shape)
#	print("startx: " + str(start_x) + " startY: " + str(start_y) + " num_cols: " + str(num_cols) + " num_rows: " + str(num_rows))
	for i in range(start_y, start_y + num_rows):
		for j in range(start_x, start_x + num_cols):
#			print("board Y: " + str(i))
#			print("board X: " + str(j))
#			print("Shape: " + str(shape.my_shape[i - start_y][j -start_x]))
			board[i][j] = shape.my_shape[i - start_y][j -start_x]

func get_rows():
	return ROWS

# TODO
# render shape
# 2d array for board
# drop shape
# rotate shape
# collision detection
