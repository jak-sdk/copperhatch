extends KinematicBody

var path = []
var speed = 15

onready var nav = ui.nav
onready var space = game.get_world().direct_space_state

onready var shoot_ray_canvas = draw.get_node("shoot_rays")

var rng = RandomNumberGenerator.new()


## 
onready var health = 100
onready var ap = 100


# Attacking may need it's own script eventually
# we should cache an attack based on 
#  - who it's against 
#  - the desired AP spend
#  - single, burst, auto with x bullets 
# if we move, clear the cache (signal?) we're unlikely to ever come back the the same spot (unless we switch to grid based movement...)
var attack_cache = {}


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

func available_move_distance(): # TODO
	# posture (crouch, prone, stand, run)
	# wounds
	# weight
	# terrain?
	return 15 #self.ap/3.0

func get_path_to(point, limit_by_ap=true):
	var move_limit = self.available_move_distance()
	
	var init_path_to = nav.get_simple_path(self.translation, point)
	var path_to = []
	
	if limit_by_ap == false:
		path_to = init_path_to
		
	if limit_by_ap == true:
		var distance = 0
		var prev_point = init_path_to[0]

		for i in init_path_to:
			var next_step = (i - prev_point).length()
			if distance + next_step > move_limit:
				# we can actually move
				var restrict_step_to = move_limit - distance
				path_to.append((i - prev_point).normalized() * restrict_step_to + prev_point)
				break
			else:
				path_to.append(i)
				distance += next_step
				prev_point = i
	return path_to
	

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

func attack():
	# this uses the precalculated attack we used earlier to provide a hit chance
	
	pass
	

func predict_attack(character, shots = 1):
	# this function creates a firing solution that we can query
	# for calculating hit chance 
	
	# lets try to keep our shots in a cone
	# angle deviation is a function of: skill, ap spent on shot
	var number_of_simulations = 3

	shoot_ray_canvas.clear()
	
	var potential_shots = []
	rng.randomize()
	for i in range(number_of_simulations):
		var potential_shot = {}
		potential_shot['shots'] = []
		potential_shot['hit'] = false
		
		var deviation = Vector3(rng.randf_range(-1, 1),
								rng.randf_range(-1, 1),
								rng.randf_range(-1, 1))
		var direction_to_target = character.translation - self.translation
		var ray = null
		var hits = 0
		for shot in range(shots):
			var shootdir = direction_to_target.normalized() + (0.03 * deviation)
			ray = space.intersect_ray(self.translation, shootdir*100)
			
			# TODO each shot should affect the next bullet like ricochet
			# gun recoil - character strength? 
			# Does skill affect it? maybe extremely low skill will affect it badly
			#   but after being somewhat proficient you know how to steady a gun and then raw strength takes over
			deviation.y += 0.5
			
			potential_shot['shots'].append(ray)
			
			if ray.size() > 0:
				#draw_shot(shootdir, 'red')
				hits+=1
			else:
				pass
				#draw_shot(shootdir, 'white')
				
		if hits > 0:
			potential_shot['hit'] = true
		potential_shots.append(potential_shot)
		
	var chance_to_hit = 0
	var simulations_that_hit = 0
	for i in range(number_of_simulations):
		if potential_shots[i]['hit'] == true:
			simulations_that_hit +=1
	
	chance_to_hit = float(simulations_that_hit) / float(number_of_simulations)
	print(chance_to_hit)
	
	self.attack_cache = potential_shots
			
		
func draw_shot(shootdir, color="white"):
	shoot_ray_canvas.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	shoot_ray_canvas.set_color(ColorN(color))
	shoot_ray_canvas.add_vertex(self.translation)
	shoot_ray_canvas.add_vertex(shootdir*50)
	shoot_ray_canvas.end()
