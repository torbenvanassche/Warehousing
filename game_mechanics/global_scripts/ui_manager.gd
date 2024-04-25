class_name UserInterface
extends Node

var window_data: Dictionary = {};
var scene_history: Array[Node] = []

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS;
	for c in get_children():
		c.visible = false;
		
func add_window(n: String, control: Control):
	if n == "":
		printerr("There is no name defined for " + control.name)
	if(window_data.has(n)):
		printerr(n + " already exists in the ui manager.")
		return;
	window_data[n] = control;

func _unhandled_input(event):
	if event.is_action_pressed("open_inventory") && !get_tree().paused:
		enable_ui(get_subwindow("INVENTORY"))
		
	if event.is_action_pressed("cancel") && is_ui_closed():
		toggle_pause();
		
func toggle_pause():
	get_viewport().set_input_as_handled()
	Manager.pause(!get_tree().paused)
	if get_tree().paused:
		enable_ui(get_subwindow("PAUSE"), true)
	else:
		disable_ui(get_subwindow("PAUSE"), false)

func is_ui_closed(exceptions: Array = [get_subwindow("PAUSE")]):
	return get_children().all(func(x): return !x.visible || exceptions.has(x));
	
func get_subwindow(s: String) -> Node:
	if window_data.has(s):
		if window_data[s] is NodePath:
			window_data[s] = get_node_or_null(window_data[s]);
		return window_data[s];
	else: 
		printerr("The provided key: " + s +  " does not have an associated window.")
		return null;

func enable_ui(to_enable: Node, add_to_undo_stack: bool = true, options: Dictionary = {}):
	if options.has("hide") && options.hide is bool:
		options.hide.visible = options.hide;

	if to_enable:
		if to_enable.has_method("on_enable"):
			to_enable.on_enable(options)
		
		if add_to_undo_stack && !scene_history.has(to_enable):
			scene_history.append(to_enable);
		
func disable_ui(to_disable: Node, return_to_previous = true):
	to_disable.visible = false;
	if scene_history.has(to_disable):
		scene_history.erase(to_disable);
	if return_to_previous && scene_history.size() != 0:
		scene_history.back().visible = true;
	Manager.pause(!is_ui_closed())
	
func reset_history():
	scene_history.clear()

func get_global_mouse_position():
	return get_viewport().get_mouse_position()
