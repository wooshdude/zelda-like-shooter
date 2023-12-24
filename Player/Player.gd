extends CharacterBody2D

@export var speed: float
@onready var camera = $Camera2D
@onready var ui = $UI

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _enter_tree():
	set_multiplayer_authority(str(self.name).to_int())


func _ready():
	ui.visible = is_multiplayer_authority()
	camera.enabled = is_multiplayer_authority()
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _physics_process(delta):
	if not is_multiplayer_authority(): return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	if direction:
		velocity = lerp(velocity, direction * speed, 0.5)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.8)

	move_and_slide()
