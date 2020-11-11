extends KinematicBody

var path = []
var speed = 15

onready var nav = ui.nav
onready var space = game.get_world().direct_space_state

onready var shoot_ray_canvas = draw.get_node("shoot_rays")

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	connect('mouse_entered', self, '_on_foo_mouse_entered')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
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
	self.path = self.get_path_to(point)
	draw_path(path)

func get_path_to(point):
	return nav.get_simple_path(self.translation, point)

	
func draw_path(path_array):
	var im = draw.path
	im.clear()
	im.begin(Mesh.PRIMITIVE_POINTS, null)
	im.add_vertex(path_array[0])
	im.add_vertex(path_array[path_array.size() - 1])
	im.end()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path_array:
		im.add_vertex(x)
	im.end()


func _on_foo_mouse_entered():
	print("You moused over ", self)
	if self.is_npc():
		ui.enemy_enter_mouse_over(self)

func is_npc():
	return !self.is_pc()

func is_pc():
	return pcs.is_pc(self)

func _on_foo_mouse_exited():
	# ERROR this doesn't work for some reason
	#print("Your mouse left ", self)
	ui.enemy_exit_mouse_over(self)
	
func fire_at(character, shots = 1):
	# lets try to keep our shots in a cone
	# angle deviation is a function of: skill, ap spent on shot

	shoot_ray_canvas.clear()
	
	var potential_shots = []
	rng.randomize()
	for i in range(10):
		var deviation = Vector3(rng.randf_range(-1, 1),
								rng.randf_range(-1, 1),
								rng.randf_range(-1, 1))
		var direction_to_target = character.translation - self.translation
		
		var shootdir = direction_to_target.normalized() + (0.1 * deviation)
		var ray = space.intersect_ray(self.translation, shootdir*100)
		potential_shots.append(ray)
		
		shoot_ray_canvas.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		if ray.size() > 0:
			shoot_ray_canvas.set_color(ColorN("red"))
			print(" we got im")
		else:
			shoot_ray_canvas.set_color(ColorN("white"))
		
		shoot_ray_canvas.add_vertex(self.translation)
		shoot_ray_canvas.add_vertex(shootdir*50)
		shoot_ray_canvas.end()
		#print(ray)
		
