extends Control

var ap_spend = 10
var aiming_at = null
var attack_type = 'single'

func _ready():
	pass

func aim_at(character):
	self.aiming_at = character
	var screenpos = camera.cam.unproject_position(character.translation)
	set_position(screenpos) #Vector2(screenpos.x, screenpos.y)
	
	
	set_accuracy()
	
	#$m_dialogue/scroll.add_message("You aim at ...")
	
	set_visible(true)


func set_accuracy():
	var cc = pcs.get_selected_pc()
	
	self.ap_spend = min(self.ap_spend, cc.ap)
	cc.predict_attack(self.aiming_at, self.ap_spend)
	
	var chance_to_hit = cc.attack_cache[self.aiming_at.name+","+str(self.ap_spend)+","+self.attack_type]['chance_to_hit']
	# 0 -> scale:6   1 -> scale:0.3
	var reticle_scale = -5.7 * chance_to_hit + 6
	get_node('reticle/circle').scale = Vector2(reticle_scale, reticle_scale)
	
	$reticle/hit_chance_label.text = str(round(chance_to_hit*100)) + "%"

func increase_aim_spend():
	self.ap_spend = min(ap_spend + 10, pcs.get_selected_pc().ap)
	set_accuracy()
	
func decrease_aim_spend():
	self.ap_spend = max(ap_spend - 10, 10)
	set_accuracy()
