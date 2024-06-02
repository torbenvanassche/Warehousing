extends Control

@onready var back_button: Button = $back_button;

func _ready():
	back_button.pressed.connect(SceneManager.instance.to_previous_scene)

func on_enable():
	pass
