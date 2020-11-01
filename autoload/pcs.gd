extends Spatial

var selected_pc = 0
onready var pc_list = get_children()

func _ready():
	#print(pc_list)
	pass

func get_pcs():
	return get_children()

func get_selected_pc():
	if selected_pc == null or selected_pc >= pc_list.size() or selected_pc < 0:
		selected_pc = 0
	return pc_list[selected_pc]

func set_selected_pc(obj):
	for i in pc_list.size():
		if pc_list[i] == obj:
			selected_pc = i

func is_pc(obj):
	for pc in pc_list:
		if obj == pc:
			return true
	
func next_pc():
	if selected_pc >= pc_list.size() - 1:
		selected_pc = 0;
	else:
		selected_pc += 1
	print("next pc ", selected_pc)
func prev_pc():
	if selected_pc == 0:
		selected_pc = pc_list.size() - 1;
	else:
		selected_pc -= 1
	print("prev pc ", selected_pc)
