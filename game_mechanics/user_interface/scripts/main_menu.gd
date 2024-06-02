extends Control

@onready var new_game_button: Button = $Buttons/VBoxContainer/new_game;
@onready var load_game_button: Button = $Buttons/VBoxContainer/load_game;
@onready var settings_button: Button = $Buttons/VBoxContainer/settings;
@onready var credits_button: Button = $Buttons/VBoxContainer/credits;
@onready var quit_button: Button = $Buttons/VBoxContainer/quit;
	
func _ready():
	new_game_button.pressed.connect(SceneManager.instance.set_active_scene.bind("new_game_file_creator", false))
	
func on_enable():
	pass
