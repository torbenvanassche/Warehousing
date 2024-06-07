extends Control

@onready var back_button: Button = $back_button;
@onready var save_container: Control = $MarginContainer/VBoxContainer2/save_slots;
var save_root_path: String = "user://saves";

func _ready():
	back_button.pressed.connect(SceneManager.instance.to_previous_scene)
	SceneManager.instance.game_loaded_timestamp = Time.get_datetime_dict_from_system(false)

func on_enable():
	if not DirAccess.dir_exists_absolute(save_root_path):
		DirAccess.make_dir_absolute(save_root_path)
		
	var files = DirAccess.get_files_at(save_root_path).slice(0, save_container.get_child_count());
	for f: String in files: 
		save_container.get_child(int(f)).load(f.get_basename())
