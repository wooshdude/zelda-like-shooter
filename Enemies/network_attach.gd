extends Node
class_name NetworkAttach

@export var entity: Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rpc("_remote_update_position", entity.global_position)


@rpc("call_local", "any_peer", "reliable")
func _remote_update_position(pos):
	entity.global_position = pos
