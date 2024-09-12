extends CanvasLayer

const BTN_BORDER = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_width = DisplayServer.window_get_size()[0]
	var screen_height = DisplayServer.window_get_size()[1]
	var h_center = screen_width / 2
	var v_center = screen_height / 2
	
	# centre the start button
	var btn_start_width = $start_button.shape.size[0]
	var btn_start_height = $start_button.shape.size[1]
	$start_button.position = Vector2(h_center - (btn_start_width / 2), v_center + (BTN_BORDER * 4 ) - (btn_start_height / 2))
	
	# position all the contols relative to their size and screen size
	$left.position = Vector2(BTN_BORDER, (screen_height - BTN_BORDER - $left.shape.size[1]  ))
	$right.position = Vector2(BTN_BORDER + ($left.shape.size[0] * 2.5), (screen_height - BTN_BORDER - ($right.shape.size[1] * 2)  ))
	$down.position = Vector2(BTN_BORDER + $down.shape.size[0] * 1.75, (screen_height - BTN_BORDER ))
	
	$a.position = Vector2(screen_width - BTN_BORDER - $a.shape.radius * 3 , screen_height - BTN_BORDER - $a.shape.radius * 2 )
	$b.position = Vector2(screen_width - BTN_BORDER - $a.shape.radius * 2 , screen_height - BTN_BORDER - $a.shape.radius * 4 )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
