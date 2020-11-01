extends Control

var pc = null

func display(some_pc):
	# set name to pc.name
	# set picture to pc.picture
	pc = some_pc
	self.refresh()
	pass

func refresh():
	if self.pc == null:
		self.hide()
		return
	
	$name.text = pc.name
	self.show()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print("setting selected pc to ", self.pc)
		pcs.set_selected_pc(self.pc)

func _ready():
	pass
