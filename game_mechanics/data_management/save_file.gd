class_name SaveFile
extends Resource

var game_loaded_timestamp: Dictionary;
var last_time_played: Dictionary;
var time_played_since_save: int;

var file_name: String;

func open():
	game_loaded_timestamp = Time.get_datetime_dict_from_system(false)

func save(save_name: String = file_name):
	last_time_played = Time.get_datetime_dict_from_system(false)
	var session_time = calculate_session_time(game_loaded_timestamp, last_time_played)
	
	#call this to make sure that saving without exiting doesn't malfunction
	game_loaded_timestamp = Time.get_datetime_dict_from_system(false)
	time_played_since_save += session_time;
	file_name = save_name

func calculate_session_time(start_time: Dictionary, end_time: Dictionary) -> int:
	var start_timestamp = Time.get_unix_time_from_datetime_dict(start_time)
	var end_timestamp = Time.get_unix_time_from_datetime_dict(end_time)
	return end_timestamp - start_timestamp
	
func get_readable_save_time():
	return String("{day}-{month}-{year} {hour}:{minute}").format(game_loaded_timestamp)

func get_total_time_played() -> String:
	var hours = time_played_since_save / 3600
	var minutes = (time_played_since_save % 3600) / 60
	return "%02d:%02d" % [hours, minutes]
