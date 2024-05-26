extends Control

@onready var bubble: Control = $SpeechBubble;
@export var text_area: Label;

func _process(_delta):
	bubble.position = Manager.camera.unproject_position(get_parent().global_position)
	print(bubble.position)

func set_text(str: String):
	text_area.text = str;
