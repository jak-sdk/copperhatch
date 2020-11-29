extends Control


func _ready():
	pass


func update_turn_indicator():
	var output = ""
	if game.state == "TURN":
		output += "Encounter! "
		if game.turn == "PLAYER":
			output += "Players Turn!"
		elif game.turn == "NPC":
			output += "Waiting for Player Turn!"
		
	
	$mcont/label.text = output
