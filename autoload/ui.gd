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
	$b_end_turn.connect("pressed", self, "player_end_turn")
	pass # Replace with function body.

func _unhandled_input(event):
	events_always_available(event)
	if game.player_can_interact():
		events_onturn_available(event)

func events_always_available(event):
	if event is InputEventMouseButton and self.ui_rc_action == null:
		if event.button_index == BUTTON_WHEEL_UP:
			camera.cam.size -= 1
		if event.button_index == BUTTON_WHEEL_DOWN:
			camera.cam.size += 1
	# mouse movement triggers checks
	if event is InputEventMouseMotion:
		var from = camera.cam.project_ray_origin(event.position)
		var to = from + camera.cam.project_ray_normal(event.position) * 100

		# figure out what we are interacting with
		var ray_result = space.intersect_ray(from, to)
		if ray_result.size() > 0: # we hit something
			#print("We are mousing over", ray_result)
			# right now we offload to object.on_mouseEntered signal to trigger this stuff
			pass
		else:
			# we aren't over anything
			# generic function mouse_over_nothing()??
			#   we should have a re-usable function for clearing the slate
			self.mouse_over = null
			$m_fire_reticle.set_visible(false)
			self.ui_rc_action = null
			draw_move_path_to(nav.get_closest_point_to_segment(from, to))
	if event.is_action_pressed("ui_next_pc"):
		pcs.next_pc()
	elif event.is_action_pressed("ui_prev_pc"):
		pcs.prev_pc()
	pass
	
func events_onturn_available(event):
	if event.is_action_pressed("ui_crouch"):
		pcs.get_selected_pc().crouch()
	if event.is_action_pressed("ui_stand"):
		pcs.get_selected_pc().stand()

	if event is InputEventMouseButton and self.ui_rc_action == "FIRE":
		if event.button_index == BUTTON_WHEEL_UP:
			$m_fire_reticle.increase_aim_spend()
		if event.button_index == BUTTON_WHEEL_DOWN:
			$m_fire_reticle.decrease_aim_spend()
			
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		var current_character = pcs.get_selected_pc() 
		# right click
		
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
					pcs.get_selected_pc().attack(ray_result['collider'], $m_fire_reticle.ap_spend) # use current ap spend and weapon type
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
	pass

func enemy_enter_mouse_over(enemy):
	$m_fire_reticle.aim_at(enemy)
	self.mouse_over = enemy
	self.ui_rc_action = "FIRE"
	
func enemy_exit_mouse_over(enemy):
	$m_fire_reticle.set_visible(false)

func player_end_turn():
	game.player_end_turn()


func draw_move_path_to(point):
	# if we're in free roam
	#   : move path can be as far as you like
	# or encounter
	#   : move path is limited by available AP
	var move_path = [] 
	if game.state == "TURN":
		#cut the path short by ap
		move_path = pcs.get_selected_pc().get_path_to(point, true)
	else:
		move_path = pcs.get_selected_pc().get_path_to(point)
	
	draw_path(move_path)
	
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
	

