extends Node
class_name HealthComponent

@export var health = 1: set = set_health, get = get_health
@export var entity: CharacterBody2D

@export var hurt_box: HurtboxComponent

signal dead


func _ready():
	if not hurt_box: hurt_box = HurtboxComponent.new()


@rpc("call_local", "any_peer", "reliable")
func set_health(amount):
	health += amount
	print(health)
	
	if entity:
		if health <= 0:
			entity.queue_free()


func get_health():
	return health

func is_alive():
	if health <= 0:
		return false
	else:
		return true
