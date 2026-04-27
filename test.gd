extends Node2D

var waiting_for_tap := false
var keys = []

func _input(event):
	if event is InputEventKey and event.pressed == true:
		if event.keycode == 74:
			print("Awaiting Tap...")
			waiting_for_tap = true
		elif waiting_for_tap:
			if event.keycode == KEY_ENTER:
				submit_tap()
			else:
				keys.append(event.as_text())

func submit_tap():
	waiting_for_tap = false
	var id_number := "".join(keys)
	keys = []
	print("Tap Received")
	print(id_number)
