extends Spatial

# game mode 
# FREE - free roam, everything is like
# TURN - turn based encounter
# PAUS - paused (needed? godot has global pause) 
var state = "TURN"
	
# turn
# PLAYER
# NPC
var turn = "PLAYER"

func _ready():
	pass

func player_can_interact():
	if state =="FREE" or (state == "TURN" and turn == "PLAYER"):
		return true
	else:
		return false

func enter_encounter():
	self.state = "TURN"

func exit_encounter():
	start_freeroam()
	
func start_freeroam():
	self.state = "FREE"

func player_end_turn():
	if turn == "PLAYER": # prevent hax
		end_turn()
	
func end_turn():
	self.turn = whos_turn_is_next()
	
func whos_turn_is_next():
	if turn == "PLAYER":
		return "NPC"
	elif turn == "NPC":
		return "PLAYER"
	else:
		pass # panic
