@tool
extends Resource
class_name Weapon

@export var name: String
@export var sprite: Texture : set = set_sprite
var sprite_path: String
@export var damage: int
@export var rpm: int
@export var speed: int
@export var bullet: TrailData


func set_sprite(texture):
	sprite = texture
	sprite_path = texture.resource_path

