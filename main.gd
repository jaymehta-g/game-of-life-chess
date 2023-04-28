extends Node2D

@onready var board: Board = $Board

@onready var next_frame: Button = $"UI/Next Frame"
@onready var auto: CheckBox = $UI/Auto
@onready var speed: HSlider = $UI/Speed

@onready var speed_label: Label = $UI/Speed/Value

func _ready() -> void:
	next_frame.pressed.connect(board.calculate_next_frame)
	speed.value_changed.connect(func(value):
		board.delay_time = value
		speed_label.text = str(value)
	)
	auto.toggled.connect(func(value): board.auto = value)
