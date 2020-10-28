extends Spatial

onready var nav = get_node('/root/scene/Navigation')
#onready var deb = get_tree().get_root().get_children()
onready var space = game.get_world().direct_space_state

onready var m_interact = $m_interact

# this sets the default right-click action on a location
# l -> LOOK -> look
# f -> FIRE -> fire at
onready var ui_rc_action = null

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("debug: ", deb)
#	for i in deb:
#		print(i.name)
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("ui_next_pc"):
		pcs.next_pc()
	elif event.is_action_pressed("ui_prev_pc"):
		pcs.prev_pc()

	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		var current_character = pcs.get_selected_pc() 
		print("right click")
		# DELETE this may be redundant
		ui.m_interact.set_visible(false)
		
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
				current_character.look_at(target_point)
			

		
	if null and event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		var from = camera.cam.project_ray_origin(event.position)
		var to = from + camera.cam.project_ray_normal(event.position) * 1000
		var target_point = nav.get_closest_point_to_segment(from, to)
		
		# show interact menu at target point??
		var screenpos = camera.cam.unproject_position(target_point)
		$m_interact.set_position(screenpos) #Vector2(screenpos.x, screenpos.y)
		$m_dialogue/scroll.add_message("moving m_interact to new location ")
		$m_interact.set_visible(true)
