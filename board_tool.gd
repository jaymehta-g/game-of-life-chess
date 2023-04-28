@tool
extends Node2D

@export var piece_scene : PackedScene
@onready var pieces = $Pieces

const piece_off = 145

func _ready():
	for child in pieces.get_children():
		pieces.remove_child(child)
	for r in range(0,8):
		for c in range(0,8):
			var child : PieceRect = piece_scene.instantiate()
			pieces.add_child(child)
			child.position = Vector2(c*piece_off, r*piece_off)
			var offset = (Vector2.UP + Vector2.LEFT) * piece_off * 3.5
#			offset += (Vector2.DOWN + Vector2.RIGHT) * piece_off * 0.5
			child.position += offset
			child.owner = get_tree().edited_scene_root

