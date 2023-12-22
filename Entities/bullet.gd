extends Area2D

@export var speed: float = 1
@onready var trail = $TrailEffect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += Vector2(1,0).rotated(rotation) * speed
