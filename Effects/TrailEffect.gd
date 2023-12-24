extends Node
class_name TrailEffect
#  Controlls the visual body of the snake
#  Does not influence movement

@export var entity: Node2D
@export var data: TrailData = preload("res://Effects/default.tres")

var bodies: Array[Sprite2D]		# Stores individual segment objects
var points: Array[Vector2]		# Saves previous positions
var line = Line2D.new()
var outline = Line2D.new()

var gradient = Gradient.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	gradient.add_point(0, Color(Color.RED))
	gradient.add_point(1, Color(Color.GREEN))
	
	# Creates the line used for the body
	line.width_curve = data.taper
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.default_color = data.color
	line.width = data.scale
	
	#line.gradient = gradient
	
	outline.width_curve = data.taper
	outline.joint_mode = Line2D.LINE_JOINT_ROUND
	outline.begin_cap_mode = Line2D.LINE_CAP_ROUND
	outline.end_cap_mode = Line2D.LINE_CAP_ROUND
	outline.width = data.outline_width + data.scale
	outline.default_color = data.outline_color
	
	if data.use_outline: self.add_child(outline)
	self.add_child(line)
	
	# Adds segment objects
	for i in range(data.segments):
		var new_segment = Sprite2D.new()
		new_segment.top_level = true
		new_segment.global_position = entity.global_position
		bodies.append(new_segment)
		new_segment.scale *= data.taper.sample(float(i)/float(data.segments))
		self.add_child(new_segment)
		line.add_point(Vector2.ZERO)
		outline.add_point(Vector2.ZERO)
	
	# Fills the points array
	for i in range(data.segments * data.spacing):
		points.push_front(entity.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	points.push_front(entity.global_position)
	
	# Manages points array overflow
	if points.size() > data.segments * data.spacing:
		points.remove_at(points.size()-1)
	
	var time = Time.get_ticks_msec()
	# Calculate the scale factor using the sine function
	
	# Sets segment object positions
	for i in range(data.segments):
		bodies[i].global_position = points[i * data.spacing]  # Sets global position, offset by spacing
		line.set_point_position(i,bodies[i].global_position)
		outline.set_point_position(i,bodies[i].global_position)

func hide():
	for i in get_children():
		i.hide()
