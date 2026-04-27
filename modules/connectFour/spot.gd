extends AspectRatioContainer

@onready var colors = $"../..".colors

func setState(value):
	$Panel/CenterContainer/Panel.modulate = colors[value]
