class_name SaveFile
extends Resource

var timestamp: Dictionary;

func save():
	timestamp = Time.get_datetime_dict_from_system(false);
	
func get_readable_save_time():
	return String("{day}-{month}-{year} {hour}:{minute}").format(timestamp)

