class_name SaveFile
extends Resource

var last_time_played: Dictionary;
var time_played: int;
var save_id: String;
var slot_number: int;

var user_defined_string: String;
var file_on_disk: bool = false;
	
func _init(id: String):	
	save_id = id;
	
	var save_path = "user://saves/" + id + ".sav";
	if not FileAccess.file_exists(save_path):
		return;
		
	file_on_disk = true;
	var file = FileAccess.open(save_path, FileAccess.READ);
	var save_data = generate_save_dictionary();
	for key in save_data.keys():
		set(key, file.get_var())
	file.close();
	
func save():
	last_time_played = Time.get_datetime_dict_from_system(false)
	var session_time = calculate_session_time(SceneManager.instance.game_loaded_timestamp, last_time_played)
	
	#call this to make sure that saving without exiting doesn't malfunction
	SceneManager.instance.game_loaded_timestamp = Time.get_datetime_dict_from_system(false)
	time_played += session_time;
	
	#actually save the resource
	var save_path = "user://saves/" + save_id + ".sav";
	var file = FileAccess.open(save_path, FileAccess.WRITE);
	var save_data = generate_save_dictionary();
	for key in save_data.keys():
		file.store_var(save_data[key])
	file.close();
	
func generate_save_dictionary() -> Dictionary:
	return {
		"last_time_played": last_time_played,
		"time_played": time_played,
		"user_defined_string": user_defined_string,
	}

func calculate_session_time(start_time: Dictionary, end_time: Dictionary) -> int:
	var start_timestamp = Time.get_unix_time_from_datetime_dict(start_time)
	var end_timestamp = Time.get_unix_time_from_datetime_dict(end_time)
	return end_timestamp - start_timestamp
	
func get_readable_save_time():
	return String("{day}-{month}-{year} {hour}:").format(last_time_played) + str("%02d" % last_time_played["minute"])
	
func get_total_time_played() -> Array:
	var hours: int = int(time_played / 3600.0)
	var minutes: int = int((time_played % 3600) / 60.0)
	return [hours, minutes]

func get_total_time_played_as_string() -> String:
	return "%02d:%02d" % get_total_time_played();
