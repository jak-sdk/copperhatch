extends Control

var pc_id = null

func display(some_pc_id):
	# set name to pc.name
	# set picture to pc.picture
	pc_id = some_pc_id
	self.refresh()
	pass

func refresh():
	if self.pc() == null:
		self.hide()
		return
	
	$ap_bar.max_value = 200
	$ap_bar.value = pc().ap
	$health_bar.max_value = 100
	$health_bar.value = pc().health
	#print("refreshing ap bar " + str(pc().ap) + " for " + str(pc().name))
	$name.text = pc().name
	self.show()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print("setting selected pc to ", self.pc())
		pcs.set_selected_pc(self.pc())

func _ready():
	pass
	
func pc():
	if pc_id:
		return instance_from_id(pc_id)
	else:
		return null
