extends Node2D

@export var player: CharacterBody2D

const BULLET = preload("res://Entities/bullet.tscn")
@onready var sprite_2d = $Sprite2D

func _enter_tree():
	set_multiplayer_authority(str(player.name).to_int())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_multiplayer_authority(): return
	look_at(get_global_mouse_position())
	if self.rotation_degrees > 360 or self.rotation_degrees < -360:
		self.rotation_degrees = 0
	
	if get_global_mouse_position().x > global_position.x:
		sprite_2d.flip_v = false
	else:
		sprite_2d.flip_v = true
	
	if Input.is_action_just_pressed("fire"):
		rpc("spawn_bullet")


@rpc("call_local", "authority", "reliable")
func spawn_bullet():
	var new_bullet = BULLET.instantiate()
	new_bullet.rotation = rotation
	new_bullet.global_position = global_position
	new_bullet.top_level = true
	get_tree().root.add_child(new_bullet)
