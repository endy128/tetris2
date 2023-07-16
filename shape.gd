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

# FIXME!!
func _check_if_can_rotate(direction):
	# check if the proposed rotation will put some of the shape off the
	# board and if so move position.x appropriately
	pass

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
	return len(self.frames[self.frame_index])
	

