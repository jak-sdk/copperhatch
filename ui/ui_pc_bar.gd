extends Control


func refresh_headboxes():
	var pc_list = pcs.get_pcs()
	for i in range(1,6):
		if i <= pc_list.size():
			set_headbox(i,pc_list[i-1])
			#get_node("pc_boxes/"+str(i)).display(pc_list[i-1])
		else:
			set_headbox(i,null)
			#get_node("pc_boxes/"+str(i)).display(null)
	

func set_headbox(index, pc):
	get_node("pc_boxes/"+str(index)).display(pc)
	

func _ready():
	refresh_headboxes()
	
