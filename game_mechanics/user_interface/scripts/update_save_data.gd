extends Node

@onready var file: SaveFile = SaveFile.new();

func _ready():
	update_file()
	
func update_file():
	file.save();
