extends ScrollContainer

func add_message(text):
	var m = Label.new()
	m.text = text
	m.set("custom_colors/font_color", Color(1,0,0))
	$VBoxContainer.add_child(m)
	scroll_vertical = get_v_scrollbar().max_value

func _ready():
	pass
