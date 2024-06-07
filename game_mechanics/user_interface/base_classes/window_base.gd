class_name DraggableControl
extends Control

@export var id: String = "";

@onready var vp := get_viewport()
@onready var top_bar: ColorRect = $VBoxContainer/topbar;
@onready var close_button: Button = $VBoxContainer/topbar/HBoxContainer/Button;
@onready var title: Label = $VBoxContainer/topbar/HBoxContainer/MarginContainer/Title;
@onready var content_panel: ColorRect = $VBoxContainer/content;
@onready var background_color: Color = $VBoxContainer/content.color;

@export_enum("display", "no_header", "none") var display_mode: String = "display"
@export_enum("mouse", "center", "override") var position_options: String = "center";
var initial_position: Vector2;

@export var store_position: bool = false;
@export var override_position: Vector2;
@export var override_size: Vector2;
@export var to_enable: Node;
@export var return_on_close: bool = true;

signal close_requested();
signal change_title(name: String);

var dragging := false
var stored_position:Vector2;

func _ready():
	close_button.pressed.connect(close_window);
	close_requested.connect(close_window)
	top_bar.gui_input.connect(handle_input)
	change_title.connect(_change_title)
	
	UserInterface.instance.add_window(id, self)
	
	if to_enable && "window" in to_enable:
		to_enable.window = self;
	
	if override_size != Vector2.ZERO:
		self.set_deferred("size", override_size)
		top_bar.custom_minimum_size = Vector2(override_size.x, 50)
		content_panel.custom_minimum_size = Vector2(override_size.x, override_size.y - top_bar.size.y)
	
func on_enable(options: Dictionary = {}):
	if visible:
		return
		
	visible = true;
	if to_enable && to_enable.has_method("on_enable"):
		to_enable.on_enable(options)
		
	match display_mode:
		"display":
			top_bar.visible = true;
			content_panel.color = background_color;
			pass
		"no_header":
			top_bar.visible = false;
			content_panel.color = background_color;
			pass
		"none":
			top_bar.visible = false;
			content_panel.color = Color.TRANSPARENT;
			pass
	
	match position_options:
		"mouse":
			initial_position = get_tree().root.get_viewport().get_mouse_position();
		"center":
			initial_position = get_viewport_rect().size / 2
		"override":
			initial_position = override_position;	
	position = initial_position - size / 2;
	
	if store_position:
		position = stored_position;

func _change_title(s: String):
	title.text = s;

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		dragging = event.pressed
	elif dragging and event is InputEventMouseMotion:
		position += event.relative
	else:
		return
	vp.set_input_as_handled()

func close_window():
	if store_position:
		stored_position = position;
	UserInterface.instance.disable_ui(self, return_on_close)
	
func _unhandled_input(event):	
	if event.is_action_pressed("cancel") && visible:
		vp.set_input_as_handled()
		close_requested.emit()
