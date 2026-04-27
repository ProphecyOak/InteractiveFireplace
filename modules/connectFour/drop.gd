extends Control

@onready var colors = $"../..".colors

func setState(value):
	$Left.visible = value >= 0
	$Right.visible = value >= 0
	$Square.scale = Vector2(1.25,1.25) if value >= 0 else Vector2(1,1)
	modulate = colors[value]
