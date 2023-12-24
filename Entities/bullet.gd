extends Area2D

@export var speed: float = 1
@export var trail: TrailEffect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += Vector2(1,0).rotated(rotation) * speed


func _on_body_entered(body):
	trail.hide()
	monitorable = false
	monitoring = false
	speed = 0
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		print(area)
		area.rpc("hit",-1)
		queue_free()
