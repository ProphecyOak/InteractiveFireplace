extends HBoxContainer

@export var max_label: Label
@export var total_label: Label

var save_file_path := "user://savedata.csv"
var reset_held = 0

var max_size := 0:
	set(new_max):
		max_size = new_max
		max_label.text = "Current Max Votes: " + str(max_size)

var total_votes := 0:
	set(new_total):
		total_votes = new_total
		total_label.text = "Current Total Votes: " + str(total_votes)

func resolve_vote(bar_size):
	max_size = max(bar_size, max_size)
	for vote_bar in get_children():
		vote_bar.update_size()
	total_votes += 1

func _ready():
	if FileAccess.file_exists(save_file_path):
		var save_file = FileAccess.open(save_file_path, FileAccess.READ)
		print(save_file.get_as_text())

func _process(delta):
	if (Input.is_action_pressed("Red") and
		Input.is_action_pressed("Yellow") and
		Input.is_action_pressed("Green") and
		Input.is_action_pressed("Blue")):
		reset_held += delta
	else:
		reset_held = 0
	if reset_held > 5:
		reset_held = 0
		reset_bars()
		
func reset_bars():
	var save_file
	if FileAccess.file_exists(save_file_path):
		save_file = FileAccess.open(save_file_path, FileAccess.READ_WRITE)
	else:
		save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if save_file == null:
		print(FileAccess.get_open_error())
		return
	save_file.seek_end()
	save_file.store_csv_line(get_children().map(func (vote_bar):
		return str(vote_bar.bar_size - 1)
		))
	
	max_size = 0
	for vote_bar in get_children():
		vote_bar.bar_size = 0
		vote_bar.update_size()
	total_votes = 0
