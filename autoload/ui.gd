extends Spatial

onready var nav = get_node('/root/scene/Navigation')
onready var space = game.get_world().direct_space_state

onready var m_interact = $m_interact
onready var m_fire_reticle = $m_fire_reticle

# this sets the default right-click action on a location
# l -> LOOK -> look
# f -> FIRE -> fire at
onready var ui_rc_action = null #"LOOK"

var mouse_over = null

func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("ui_next_pc"):
		pcs.next_pc()
	elif event.is_action_pressed("ui_prev_pc"):
		pcs.prev_pc()

	# mouse movement triggers checks
	if event is InputEventMouseMotion:
		var from = camera.cam.project_ray_origin(event.position)
		var to = from + camera.cam.project_ray_normal(event.position) * 1000

		# figure out what we are interacting with
		var ray_result = space.intersect_ray(from, to)
		if ray_result.size() > 0: # we hit something
			#print("We are mousing over", ray_result)
			pass
		else:
			# we aren't over anything
			# generic function mouse_over_nothing()??
			self.mouse_over = null
			$m_fire_reticle.set_visible(false)
			draw_path_to(pcs.get_selected_pc().get_path_to(nav.get_closest_point_to_segment(from, to)))
			self.ui_rc_action = null
			


	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		var current_character = pcs.get_selected_pc() 
		print("right click")
		
		var from = camera.cam.project_ray_origin(event.position)
		var to = from + camera.cam.project_ray_normal(event.position) * 1000

		# figure out what we are interacting with
		var ray_result = space.intersect_ray(from, to)
		if ray_result.size() > 0: # we hit something
			if ray_result['collider'] == pcs.get_selected_pc():
				print("we clicked on ourselves")
			elif pcs.is_pc(ray_result['collider']):
				print("we clicked on a teammate")
			elif npcs.is_npc(ray_result['collider']):
				print("we clicked on an npc, attack??")
				if self.ui_rc_action == "FIRE":
					pcs.get_selected_pc().fire_at(ray_result['collider'])
			print(ray_result)
		else: # we've clicked on a spot
			# figure out what we need to do
			if self.ui_rc_action == null: # default action, move?
				var target_point = nav.get_closest_point_to_segment(from, to)
				print("moving ", current_character.name, " to ", target_point)
				current_character.move_to(target_point)
			if self.ui_rc_action == "LOOK":
				var target_point = nav.get_closest_point_to_segment(from, to)
				print("making ", current_character.name, " look at ", target_point)
				current_character.look_at(target_point, Vector3.UP)

func enemy_enter_mouse_over(enemy):
	var screenpos = camera.cam.unproject_position(enemy.translation)
	$m_fire_reticle.set_position(screenpos) #Vector2(screenpos.x, screenpos.y)
	#$m_dialogue/scroll.add_message("You aim at ...")
	$m_fire_reticle.set_visible(true)
	self.mouse_over = enemy
	draw.get_node('path')
	self.ui_rc_action = "FIRE"
	
func enemy_exit_mouse_over(enemy):
	$m_fire_reticle.set_visible(false)
	
func draw_path_to(path_array):	
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
	

