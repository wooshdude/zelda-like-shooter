extends Area2D
class_name HurtboxComponent

@export var entity: CharacterBody2D
@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer

var fling_strength: int = 10

@rpc("call_local", "any_peer", "reliable")
func hit(damage: int = 0) -> void:
	if health_component:
		health_component.rpc("set_health",damage)
