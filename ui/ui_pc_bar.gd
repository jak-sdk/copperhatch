extends Control

var _timer

func refresh_headboxes():
	var pc_list = pcs.get_pcs()
	for i in range(1,6):
		if i <= pc_list.size():
			set_headbox(i,pc_list[i-1].get_instance_id())
			#get_node("pc_boxes/"+str(i)).display(pc_list[i-1])
		else:
			set_headbox(i,null)
			#get_node("pc_boxes/"+str(i)).display(null)

func set_headbox(index, pc_id):
	get_node("pc_boxes/"+str(index)).display(pc_id)
	

func _ready():
	refresh_headboxes()
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	

func _on_Timer_timeout():
	refresh_headboxes()
