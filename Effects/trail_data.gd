@tool
extends Resource
class_name TrailData

@export var texture: Texture
@export var scale: float = 1
@export var segments: int
@export_range(0, 10, 0.1) var spacing: float
@export var taper: Curve  # Scales the body along the curve
@export_group("Color")
@export var color: Color = Color("ffffff")
@export_subgroup("Outline")
@export var use_outline: bool
@export var outline_width: int
@export var outline_color: Color


