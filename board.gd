extends Node2D
class_name Board
@onready var pieces_container = $Pieces
@onready var timer: Timer = $Timer

@onready var all_pieces := pieces_container.get_children()

var this_frame : Array[int] = []
var piece_images : Array[PieceRect] = []

const wrap_adjacency := true

var auto : bool :
	set(value):
		if value: 	timer.start()
		else: 		timer.stop()
var delay_time : float :
	set(value):
		timer.wait_time = value

func _ready():
	test_adjs()
	Console.register_env("board", self)
	for r in range(0,8): for c in range(0,8):
		var child = all_pieces[c + r * 8] as PieceRect
		child.board_pos = Vector2i(c,r)
		child.clicked.connect(_on_child_set)
		child.set_level(0)
		piece_images.append(child)
	for i in range(0,64):
		this_frame.append(0)

func index_to_xy(idx: int) -> Vector2i:
	return Vector2i(idx % 8, idx / 8)
func xy_to_index(xy : Vector2i) -> int:
	return xy.y*8 + xy.x

func wrap_xy(before: Vector2i) -> Vector2i:
	before += Vector2i(1,1) * 8
	var wrapped := Vector2i( before.x % 8, before.y % 8 )
	return wrapped

func is_pos_valid(pos: Vector2i) -> bool:
	return pos.x in range(0,8) and pos.y in range(0,8)

func count_adjs(array: Array[int], position_from : Vector2i) -> int:
	var output := 0
	for x in range(0,3): for y in range(0,3):
		var offset := Vector2i(x-1,y-1)
		var vector := offset + position_from
		if wrap_adjacency:
			vector = wrap_xy(vector)
		var idx := xy_to_index(vector)
		if not is_pos_valid(vector):
#			print("invalid! %s off of %s" % [vector, position_from])
			continue
		if x == 1 and y == 1:
			continue
		if array[idx] > 0:
			output+=1
	return output

func calculate_next_frame():
	# Use next frame
	this_frame = process_frame(this_frame)
	# Now, update the images
	update_piece_images()

func process_frame(frame: Array[int]) -> Array[int]:
	assert (frame.size()==64)
	var next : Array[int] = []
	for idx in range(0,64):
		next.append(0)
		var xy := index_to_xy(idx)
		var count = count_adjs(frame, xy)
		var this_frame_value_at = frame[idx]
		if this_frame_value_at > 0:
# If a live cell
			if count < 2:
				next[idx] = 0
			elif count > 3:
				next[idx] = 0
			elif this_frame_value_at < 5:
				next[idx] = this_frame_value_at + 1
			else:
				next[idx] = this_frame_value_at
# If a dead cell
		else:
			if count == 3:
				next[idx] = 1
	#end for
	return next

func update_piece_images():
	for idx in range(0,64):
		piece_images[idx].set_level(this_frame[idx])

func _on_child_set(who: PieceRect):
	var idx := xy_to_index(who.board_pos)
	var value_this_frame := this_frame[idx]
	if value_this_frame < 1:
		this_frame[idx] = 1
		who.set_level(1)
	else:
		this_frame[idx] = 0
		who.set_level(0)
""" Tests """

func test_adjs():
	var array : Array[int] = []
	for i in range(0,64): array.append(0)
	array[0] = 1
	array[1] = 2
#	print(count_adjs(array, Vector2i(1,1)))
	assert(count_adjs(array, Vector2i(1,1)) == 2)
func db_adj(x, y):
	return count_adjs(this_frame, Vector2i(x,y))
func db_rand():
	for idx in range(0,64):
		var rd = idx%6
		this_frame[idx] = rd
		update_piece_images()
func db_query():
	for y in range(0,8):
		var string = ""
		for x in range(0,8):
			string +=  str (this_frame[ xy_to_index(Vector2i(x,y)) ])
		print(string)
