extends Spatial

onready var path = self.get_node('path')
onready var shoot_rays = self.get_node('shoot_rays')

func _ready():
	print(self.shoot_rays)
	var m = SpatialMaterial.new()
	m.flags_use_point_size = true
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.vertex_color_use_as_albedo = true
	#m.albedo_color = Color.white
	path.set_material_override(m)
	
	var m2 = SpatialMaterial.new()
	m2.flags_use_point_size = true
	m2.flags_unshaded = true
	m2.flags_use_point_size = true
	m2.vertex_color_use_as_albedo = true 
	shoot_rays.set_material_override(m2)
	pass
