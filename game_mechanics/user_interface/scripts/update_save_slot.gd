extends Button

@onready var file: SaveFile;

func _ready():
	pressed.connect(func(): file.save())

func open(uuid: String = ""):
	file = SaveFile.new(uuid);
	$HBoxContainer/MarginContainer2/VBoxContainer/time_played.text = file.get_total_time_played_as_string()
	$HBoxContainer/MarginContainer2/VBoxContainer/last_played.text = file.get_readable_save_time();
