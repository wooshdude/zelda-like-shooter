extends Control

@onready var hotbar = $Hotbar
@onready var save_data = preload("res://Player/save_data.tres")
@onready var selection = Sprite2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for item:Weapon in save_data.weapons:
		var new_texture_rect: TextureRect = TextureRect.new()
		new_texture_rect.texture = item.sprite
		new_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		hotbar.add_child(new_texture_rect)
	
	selection.texture = preload("res://Assets/Tiles/tile_0060.png")
	selection.global_position = hotbar.get_children()[save_data.hotbar_slot].global_position
	selection.centered = false
	add_child(selection)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	selection.global_position = hotbar.get_children()[save_data.hotbar_slot].global_position
