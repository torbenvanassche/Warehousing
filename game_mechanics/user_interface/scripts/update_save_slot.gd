extends Button

@onready var file: SaveFile;

func _ready():
	pressed.connect(save)
	
func save():
	if !file:
		print(name)
		file = SaveFile.new(name)
	file.save();
	_set_content()

func open(id: String):
	file = SaveFile.new(id);
	_set_content()
	
func _set_content():
	$HBoxContainer/MarginContainer2/VBoxContainer/time_played.text = file.get_total_time_played_as_string()
	$HBoxContainer/MarginContainer2/VBoxContainer/last_played.text = file.get_readable_save_time();
