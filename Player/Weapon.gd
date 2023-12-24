extends Node2D

@export var player: CharacterBody2D
@export var save_data: SaveData

const BULLET = preload("res://Entities/bullet.tscn")
@onready var sprite = $Sprite2D
@onready var muzzle = $Muzzle
@onready var rpm_timer = $RPMTimer

var weapon: Weapon : set = set_weapon, get = get_weapon
var selected


func _enter_tree():
	set_multiplayer_authority(str(player.name).to_int())


# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_multiplayer_authority(): return
	set_weapon(save_data.weapons[save_data.hotbar_slot])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_multiplayer_authority(): return
	look_at(get_global_mouse_position())
	if self.rotation_degrees > 360 or self.rotation_degrees < -360:
		self.rotation_degrees = 0
	
	if get_global_mouse_position().x > global_position.x:
		sprite.flip_v = false
	else:
		sprite.flip_v = true
	
	if Input.is_action_pressed("fire") and rpm_timer.is_stopped():
		shoot()
	if Input.is_action_just_pressed("weapon_up"):
		scroll_weapon(+1)
	if Input.is_action_just_pressed("weapon_down"):
		scroll_weapon(-1)

func shoot():
	rpm_timer.start(60.0/float(weapon.rpm))
	var trail = weapon.bullet.resource_path
	rpc("spawn_bullet", trail)


@rpc("call_local", "authority", "reliable")
func spawn_bullet(trail):
	var new_bullet = BULLET.instantiate()
	if trail: new_bullet.trail.data = load(trail)
	new_bullet.rotation = rotation
	new_bullet.global_position = muzzle.global_position
	new_bullet.top_level = true
	new_bullet.speed = weapon.speed
	get_tree().root.add_child(new_bullet)


func set_weapon(_weapon):
	weapon = _weapon
	sprite.texture = _weapon.sprite
	rpc("set_remote_weapon", _weapon.sprite_path)


@rpc("call_remote", "authority", "reliable")
func set_remote_weapon(path):
	sprite.texture = load(path)

func scroll_weapon(value:int):
	save_data.hotbar_slot += value
	if save_data.hotbar_slot >= len(save_data.weapons):
		save_data.hotbar_slot = 0
	elif save_data.hotbar_slot < 0:
		save_data.hotbar_slot = len(save_data.weapons)-1
	print(save_data.hotbar_slot)
	set_weapon(save_data.weapons[save_data.hotbar_slot])
	return get_weapon()


func get_weapon():
	return weapon
