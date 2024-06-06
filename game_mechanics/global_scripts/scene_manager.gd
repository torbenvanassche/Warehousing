class_name SceneManager
extends Node

@export var scenes: Array[SceneInfo];
static var instance: SceneManager;
var game_loaded_timestamp: Dictionary;

signal scene_entered(scene: Node)
signal scene_exited(scene: Node)

func _ready():
	SceneManager.instance = self;
	
	#Init the game view
	set_active_scene("main_menu")

var active_scene: Node:
	get: return active_scene;
	set(new_scene):
		if !new_scene:
			return;
		if active_scene:
			active_scene.visible = false;
			scene_exited.emit(active_scene);
			if active_scene.has_method("on_disable"):
				active_scene.on_disable();
		active_scene = new_scene;
		active_scene.visible = true;
		
		scene_entered.emit(active_scene);
		if active_scene.has_method("on_enable"):
			active_scene.on_enable();
			
func get_or_create_scene(scene_name: String):	
	var filtered: Array = scenes.filter(func(scene: SceneInfo): return scene.id == scene_name);
	if filtered.size() == 0:
		printerr(scene_name + " was not found, unable to instantiate!")
	
	if filtered.size() == 1:
		var scene_info: SceneInfo = filtered[0];
		if !scene_info.node_path.is_empty():
			return get_node(scene_info.node_path);
		else:
			var node = scene_info.packed_scene.instantiate();
			add_child(node)
			scene_info.node_path = node.get_path();
			return node;
	else:
		printerr(scene_name + " was found multiple times, unable to instantiate!")
		
func node_to_info(node: Node) -> SceneInfo:
	var filtered = scenes.filter(func(x: SceneInfo): return x.id == node.name);
	if filtered.size() == 1:
		return filtered[0];
	return null
		
func set_active_scene(scene_name: String, remove_active_from_tree: bool = false):
	var previous_scene: Node = null;
	if active_scene:
		if remove_active_from_tree:
			active_scene.queue_free()
		else:
			previous_scene = active_scene;
	active_scene = get_or_create_scene(scene_name)
	
	if previous_scene:
		active_scene.set_meta("previous_scene_node", previous_scene)
		
func to_previous_scene():
	var scene_info = node_to_info(active_scene.get_meta("previous_scene_node", null));
	if scene_info:
		active_scene.remove_meta("previous_scene_node")
		set_active_scene(scene_info.id, false);
	
func get_scene_by_name(scene_name: String):
	var filtered = scenes.filter(func(x: Node): return x.name == scene_name)
	if filtered.size() > 0:
		return filtered[0]
	else:
		return null
