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
			print("We are mousing over", ray_result)
		else:
			# we aren't over anything
			# generic function mouse_over_nothing()??
			self.mouse_over = null
			$m_fire_reticle.set_visible(false)

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
	
func enemy_exit_mouse_over(enemy):
	$m_fire_reticle.set_visible(false)
	

