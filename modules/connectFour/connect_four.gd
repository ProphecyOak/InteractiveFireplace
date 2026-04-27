extends HBoxContainer
		
@onready var win_label = $"../CanvasLayer/Paused/Panel/RichTextLabel"
@onready var pause_shadow = $"../CanvasLayer/Paused"
@onready var win_notice = $"../CanvasLayer/Paused/Panel"

var game = []
var paused = true:
	set(new_value):
		paused = new_value
		pause_shadow.visible = paused
		
var current_player = 0:
	set(new_player):
		current_player = new_player
		set_selection()
		
var selected_chute = 3:
	set(new_selection):
		selected_chute = new_selection
		set_selection()
		
var colors = [
	Color("#e0c71f"),
	Color("#e01f1f"),
	Color("#143e91"),
]

func _ready():
	setup()

func setup():
	current_player = 0
	game = []
	for x in range(7):
		game.append([])
		for y in range(6):
			change_spot(x,y,-1)
	selected_chute = 3
	set_selection()
	paused = false

func change_spot(x, y, value):
	get_child(x).get_child(6-y).setState(value)
	
func set_selection():
	for x in range(7):
		get_child(x).get_child(0).setState(current_player if x == selected_chute else -1)
		
func drop():
	var chute = game[selected_chute]
	if len(chute) == 6: return
	var y = len(chute)
	game[selected_chute].append(current_player)
	change_spot(selected_chute, y, current_player)
	if check_win(selected_chute, y):
		victory()
		return
	current_player = [1, 0][current_player]

func check_win(x, y):
	var horizontal_coins = 0
	for check_x in range(7):
		if len(game[check_x]) <= y or game[check_x][y] != current_player:
			horizontal_coins = 0
		else: horizontal_coins += 1
		if horizontal_coins >= 4: return true
		
	var vertical_coins = 0
	for check_y in range(len(game[x])):
		if game[x][check_y] != current_player: vertical_coins = 0
		else: vertical_coins += 1
		if vertical_coins >= 4: return true
		
	var diagonal_coins = 0
	for check_x in range(7):
		var check_y = -check_x + y + x
		if check_y > 5 or check_y < 0: continue
		if len(game[check_x]) <= check_y or game[check_x][check_y] != current_player:
			diagonal_coins = 0
		else: diagonal_coins += 1
		if diagonal_coins >= 4: return true
		
	diagonal_coins = 0
	for check_x in range(7):
		var check_y = check_x + y - x
		if check_y > 5 or check_y < 0: continue
		if len(game[check_x]) <= check_y or game[check_x][check_y] != current_player:
			diagonal_coins = 0
		else: diagonal_coins += 1
		if diagonal_coins >= 4: return true
	return false
	
func victory():
	paused = true
	win_label.add_theme_color_override("default_color", colors[current_player])
	for x in range(10):
		win_notice.visible = not win_notice.visible
		await get_tree().create_timer(.2).timeout
	setup()

func _process(_delta):
	if not paused:
		if Input.is_action_just_pressed("ui_left"):
			selected_chute = (selected_chute + 6) % 7
		if Input.is_action_just_pressed("ui_right"):
			selected_chute = (selected_chute + 8) % 7
		if Input.is_action_just_pressed("ui_down"):
			drop()
