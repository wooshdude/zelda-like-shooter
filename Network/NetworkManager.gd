extends Node
class_name MultiplayerManager

@export_category("Multiplayer Root")

@export_group("Server Info")
@export var world: Node2D
@export var auto_host: bool
@export var port = 9999
@export var player: PackedScene
@export var spawn_point: Node2D
@export_group("Client Info")
@export var address = "localhost"
@export var client_port = 9999
@export_group("Buttons")
@export var host_button: Button
@export var join_button: Button

var enet_peer = ENetMultiplayerPeer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	host_button.pressed.connect(start_server)
	join_button.pressed.connect(join_server)
	
	if auto_host:
		start_server()


func start_server():
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	
	host_button.hide()
	join_button.hide()


func join_server():
	enet_peer.create_client(address, client_port)
	multiplayer.multiplayer_peer = enet_peer
	join_button.hide()
	host_button.hide()


func add_player(peer_id):
	var new_player = player.instantiate()
	new_player.name = str(peer_id)
	new_player.global_position = spawn_point.global_position
	
	world.call_deferred("add_child", new_player)
	print("Added new player with id " + str(peer_id))


