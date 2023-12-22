extends Node
class_name TrailEffect
#  Controlls the visual body of the snake
#  Does not influence movement

@export var entity: Node2D
@export var texture: Texture
@export var scale: float = 1
@export var segments: int
@export_range(0, 10, 0.1) var spacing: float
@export var taper: Curve  # Scales the body along the curve
@export var use_outline: bool

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
	line.width_curve = taper
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.width = scale
	
	#line.gradient = gradient
	
	outline.width_curve = taper
	outline.joint_mode = Line2D.LINE_JOINT_ROUND
	outline.begin_cap_mode = Line2D.LINE_CAP_ROUND
	outline.end_cap_mode = Line2D.LINE_CAP_ROUND
	outline.width = 8
	outline.default_color = Color("#000000")
	
	if use_outline: self.add_child(outline)
	self.add_child(line)
	
	# Adds segment objects
	for i in range(segments):
		var new_segment = Sprite2D.new()
		new_segment.top_level = true
		new_segment.global_position = entity.global_position
		bodies.append(new_segment)
		new_segment.scale *= taper.sample(float(i)/float(segments))
		self.add_child(new_segment)
		line.add_point(Vector2.ZERO)
		outline.add_point(Vector2.ZERO)
	
	# Fills the points array
	for i in range(segments * spacing):
		points.push_front(entity.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	points.push_front(entity.global_position)
	
	# Manages points array overflow
	if points.size() > segments * spacing:
		points.remove_at(points.size()-1)
	
	var time = Time.get_ticks_msec()
	# Calculate the scale factor using the sine function
	
	# Sets segment object positions
	for i in range(segments):
		bodies[i].global_position = points[i * spacing]  # Sets global position, offset by spacing
		line.set_point_position(i,bodies[i].global_position)
		outline.set_point_position(i,bodies[i].global_position)
