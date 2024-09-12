extends Node
# global variables

# get the screen dimensions
var screen = DisplayServer.window_get_size()
var SCREEN_WIDTH = screen[0]
var SCREEN_HEIGHT = screen[1]

# board settings
const COLUMNS = 10
const ROWS = 24
const STAGING = 4  # how many rows are off screen at top
var BLOCK_SIZE = SCREEN_HEIGHT / 30
const GRID_WIDTH = 1
const START_X = 20
var START_Y = (4 * - BLOCK_SIZE) + 70  # move the board up as staging area isn't rendrerd
const GRID_BG = "#000000"
const GRID_COLOUR = "#FFFFFF"


# score, level and lines extra boxes
const GAP = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("WIDTH", SCREEN_WIDTH)
	print("HEIGHT", SCREEN_HEIGHT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
