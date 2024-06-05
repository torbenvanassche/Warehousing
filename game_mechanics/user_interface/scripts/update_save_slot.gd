extends Node

@onready var file: SaveFile = SaveFile.new();

func _ready():
	file.open();
	
func _process(delta):
	file.save();
	$MarginContainer2/VBoxContainer/time_played.text = file.get_total_time_played()
	file.open()
