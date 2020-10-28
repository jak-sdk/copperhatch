extends KinematicBody

var path = []
var speed = 15

onready var camera = get_node('/root/test3/camerak/camera')

onready var nav = ui.nav


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
#	var sdirection = Vector3(0,0,0)
#	if Input.is_action_pressed("ui_left"):
#		sdirection.x -= 1
#		sdirection.z += 1
#	if Input.is_action_pressed("ui_right"):
#		sdirection.x += 1
#		sdirection.z -= 1
#	if Input.is_action_pressed("ui_up"):
#		sdirection.x -= 1
#		sdirection.z -= 1
#	if Input.is_action_pressed("ui_down"):
#		sdirection.x += 1
#		sdirection.z += 1
#	sdirection = sdirection.normalized()
#	move_and_slide(sdirection*speed, Vector3(0,1,0))
	
	if self.path.size() > 0:
		var step_size = delta * self.speed
		var destination = path[0]
		var direction = destination - self.translation
		#direction.y = 0 #self.translation.y
		
		if step_size > direction.length():
			step_size = direction.length()
			# we should also remove this node since we're about to reach it
			path.remove(0)
		
		move_and_slide(direction.normalized() * step_size / delta, Vector3.UP)
		direction.y = 0
		if direction:
			var look_at_point = translation + direction.normalized()
			look_at(look_at_point, Vector3.UP)
	
func _input(event):
	pass
	
func move_to(point):
	self.path = nav.get_simple_path(self.translation, point)
	draw_path(path)
	
func draw_path(path_array):
	var m = SpatialMaterial.new()
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white

	var im = nav.get_node("Draw")
	im.set_material_override(m)
	im.clear()
	im.begin(Mesh.PRIMITIVE_POINTS, null)
	im.add_vertex(path_array[0])
	im.add_vertex(path_array[path_array.size() - 1])
	im.end()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path:
		im.add_vertex(x)
	im.end()




		

