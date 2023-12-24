extends Node2D

@export_file() var enemy: String
@onready var timer = $Timer
@onready var multiplayer_spawner = $MultiplayerSpawner


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer_spawner.add_spawnable_scene(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_multiplayer_authority(): return
	if get_tree().get_nodes_in_group("Player") == []: return
	if not timer.is_stopped(): return
	timer.start()
	rpc("spawn_entity", enemy)


@rpc("call_local", "authority", "reliable")
func spawn_entity(path):
	var new_enemy = load(enemy).instantiate()
	new_enemy.global_position = global_position
	add_child(new_enemy)
