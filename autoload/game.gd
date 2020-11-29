extends Spatial

# game mode 
# FREE - free roam, everything is like
# TURN - turn based encounter
# PAUS - paused (needed? godot has global pause) 
var state = "FREE"
	
# turn
# PLAYER
# NPC
var turn = "PLAYER"

func _ready():
	start_freeroam()
	pass

func in_encounter():
	if self.state == "TURN":
		return true

func set_state(new_state):
	if new_state in ["TURN", "FREE", "PAUS"] and new_state != state:
		self.state = new_state
		ui.get_node('state_indicator').update_turn_indicator()

func player_can_interact():
	if state =="FREE" or (state == "TURN" and turn == "PLAYER"):
		return true
	else:
		return false

func enter_encounter():
	set_state("TURN")

func exit_encounter():
	start_freeroam()
	
func start_freeroam():
	set_state("FREE")

func player_end_turn():
	if turn == "PLAYER": # prevent hax
		end_turn()
	
func end_turn():
	if state == "FREE":
		return
	print("ending turn")
	self.turn = whos_turn_is_next()
	ui.get_node('state_indicator').update_turn_indicator()
	
	if self.turn == "NPC":
		trigger_npc_turn()
	if self.turn == "PLAYER":
		trigger_pc_turn()
	
func whos_turn_is_next():
	if turn == "PLAYER":
		return "NPC"
	elif turn == "NPC":
		return "PLAYER"
	else:
		pass # panic

func trigger_npc_turn():
	npcs.play_turn()
	
func trigger_pc_turn():
	pcs.play_turn()
