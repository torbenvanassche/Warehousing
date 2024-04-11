extends Node

#Farm
var crop_growth_modifier = 1

#Navigation mode controller
enum NAV_STYLE { CLICK, WASD }
var input_mode: NAV_STYLE = NAV_STYLE.CLICK;
signal input_mode_changed(input_mode: NAV_STYLE);

func set_input_mode(style: NAV_STYLE):
	input_mode = style;
	input_mode_changed.emit(input_mode)
	
#camera sensitivity
var camera_rotation_sensitivity = 0.01;
var camera_zoom_sensitivity = 0.5;

#menu options
var close_context_on_mouse_exit: bool = true;

#volume
var master_volume: float = 1;
signal volume_changed(new_value: float, bus_name: String);

func _ready():
	_deferred_ready.call_deferred();

func _deferred_ready():
	input_mode_changed.emit(input_mode)
	volume_changed.connect(_change_volume);
	
func _change_volume(value: float, bus_name: String):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value));
	master_volume = value;
