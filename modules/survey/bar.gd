extends VBoxContainer

@export var joy_button_name: String
@export var color: Color
@export var label_text: String

var bar_size := 0

func _ready():
	$Panel2.modulate = color
	$Panel/VBoxContainer/Label.text = label_text

func _process(_delta):
		if Input.is_action_just_pressed(joy_button_name):
			bar_size += 1
			$"..".resolve_vote(bar_size)

func update_size():
	var panel_space = ($"..".size.y - $Panel.size.y - get_theme_constant("separation"))
	var bar_height = bar_size / max(float($"..".max_size),1) * panel_space
	$Panel2.custom_minimum_size.y = max(bar_height, 5)
	$Panel/VBoxContainer/Count.text = str(bar_size)
