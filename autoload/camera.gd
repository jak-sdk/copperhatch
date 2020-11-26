extends Spatial


var speed = 20
onready var camera_body = get_node('camera_body')

onready var cam = get_node('camera_body/camera')

var starting_cam_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.starting_cam_size = cam.size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	var direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		direction.z += 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		direction.z -= 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
		direction.x += 1
	if direction.length() > 0:
		direction = direction.normalized()
		camera_body.move_and_slide(direction*speed*(cam.size / self.starting_cam_size), Vector3(0,1,0))

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & (BUTTON_MASK_MIDDLE):
			var direction = Vector3(0,0,0)
			direction.x -= event.relative.y
			direction.z -= event.relative.y
			direction.y += event.relative.y
			direction.x -= event.relative.x
			direction.z += event.relative.x
#			var camtrans_x = event.relative.x * -1
#			var camtrans_y = event.relative.y
			#camera_body.move_and_slide(Vector3(camtrans_x,camtrans_y,-camtrans_x))
			camera_body.move_and_slide(direction * (cam.size / self.starting_cam_size), Vector3(0,1,0))
			
	if null and event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				self.cam.size -= 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				self.cam.size += 1
			
	
