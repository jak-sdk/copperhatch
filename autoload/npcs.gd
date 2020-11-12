extends Spatial

var selected_npc = 0
onready var npc_list = get_children()

func _ready():
	#print(pc_list)
	pass

func get_selected_npc():
	if selected_npc == null or selected_npc >= npc_list.size() or selected_npc < 0:
		selected_npc = 0
	return npc_list[selected_npc]

func is_npc(obj):
	for npc in npc_list:
		if obj == npc:
			return true
