extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var area: Area2D
@export var move_speed: int

var target: Node2D


func enter():
	area.body_entered.connect(_on_body_entered)


func physics_update(delta):
	if not target: return
	var direction = target.global_position - enemy.global_position
	
	if direction.length() > 32:
		enemy.velocity = direction.normalized() * move_speed

	if direction.length() > 150:
		transition.emit(self, "enemywander")
	
	enemy.move_and_slide()


func _on_body_entered(body):
	target = body
