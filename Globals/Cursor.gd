extends Node2D

@onready var cursor: Sprite2D = Sprite2D.new()
@onready var cursor_sprite = preload("res://Assets/Tiles/tile_0060.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 100
	cursor.texture = cursor_sprite
	add_child(cursor)

func _process(delta):
	global_position = get_global_mouse_position()
