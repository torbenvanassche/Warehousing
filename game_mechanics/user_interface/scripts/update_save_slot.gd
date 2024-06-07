extends Button

@onready var file: SaveFile;

func _ready():
	pressed.connect(load) #get or create a save file
	pressed.connect(func(): Manager.current_save_file = file) #set the clicked file as the current file to store data to it
	pressed.connect(SceneManager.instance.set_active_scene.bind("game", true))
	
func save():
	if !file:
		file = SaveFile.new(name)
	file.save();
	_set_content()

func load(id: String = name):
	file = SaveFile.new(id);
	_set_content()
	
func _set_content():
	if file.file_on_disk:
		$HBoxContainer/MarginContainer2/VBoxContainer/time_played.text = file.get_total_time_played_as_string()
		$HBoxContainer/MarginContainer2/VBoxContainer/last_played.text = file.get_readable_save_time();
