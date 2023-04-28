extends Sprite2D
class_name PieceRect

@export var piece_textures : Array[Texture2D]

signal clicked(who: PieceRect)

var _mouse_over := false;
var mouse_over : bool :
	get: return _mouse_over

# set once!
var _set_board_pos_already := false
var _board_pos : Vector2i
var board_pos : Vector2i :
	set(value):
		assert(_set_board_pos_already == false)
		_set_board_pos_already = true
		_board_pos = value
	get:
		return _board_pos

var _is_being_clicked := false

func _on_mouse_entered():
	_mouse_over = true

func _on_mouse_exited():
	_mouse_over = false

func _process(delta):
	if mouse_over and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not _is_being_clicked:
			_is_being_clicked = true
			clicked.emit(self)
	else:
		_is_being_clicked = false

func set_level(level: int):
	assert(level <= 5)
	if level == 0:
		modulate = Color(0,0,0,0)
	else :
		modulate = Color.WHITE
		texture = piece_textures[level - 1]
