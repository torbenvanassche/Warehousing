class_name SaveFile
extends Resource

var last_time_played: Dictionary;
var time_played: int;
var uuid: String;
var slot_number: int;

var user_defined_string: String;
	
func _init(uuid: String = str(ResourceUID.create_id())):
	var save_path = "user://saves/" + uuid + ".save";
	if not FileAccess.file_exists(save_path):
		print("Save file with name " + uuid + " not found, creating.")
		return;
		
	self.uuid = uuid;
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line();
		var json = JSON.new();
		var parse_result = json.parse(json_string);
		if not parse_result == OK:
			printerr("JSON Parse error: ", json.get_error_message())
			continue;
			
		var json_data = json.get_data();
		
		for key in json_data.keys():
			set(key, json_data[key]);
			
func save():
	last_time_played = Time.get_datetime_dict_from_system(false)
	var session_time = calculate_session_time(SceneManager.instance.game_loaded_timestamp, last_time_played)
	
	#call this to make sure that saving without exiting doesn't malfunction
	SceneManager.instance.game_loaded_timestamp = Time.get_datetime_dict_from_system(false)
	time_played += session_time;
	
	#actually save the resource
	var save_data: Dictionary = generate_save_dictionary();
	var save_as_json: String = JSON.stringify(save_data)
	var save_path = "user://saves/" + uuid + ".save";
	var save_file = FileAccess.open(save_path, FileAccess.WRITE);
	save_file.store_line(save_as_json)
	
func generate_save_dictionary() -> Dictionary:
	return {
		"last_time_played": last_time_played,
		"time_played": time_played,
		"user_defined_string": user_defined_string,
		"slot_number": slot_number,
		"uuid": uuid
	}

func calculate_session_time(start_time: Dictionary, end_time: Dictionary) -> int:
	var start_timestamp = Time.get_unix_time_from_datetime_dict(start_time)
	var end_timestamp = Time.get_unix_time_from_datetime_dict(end_time)
	return end_timestamp - start_timestamp
	
func get_readable_save_time():
	return String("{day}-{month}-{year} {hour}:").format(SceneManager.instance.game_loaded_timestamp) + str("%02d" % SceneManager.instance.game_loaded_timestamp["minute"])
	
func get_total_time_played() -> Array:
	var hours = time_played / 3600
	var minutes = (time_played % 3600) / 60
	return [hours, minutes]

func get_total_time_played_as_string() -> String:
	var total_time = get_total_time_played();
	return "%02d:%02d" % get_total_time_played();
