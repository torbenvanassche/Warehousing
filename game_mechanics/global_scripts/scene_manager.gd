extends Node

@export var scenes: Array[SceneInfo];

signal scene_entered(scene: Node)
signal scene_exited(scene: Node)

var active_scene: Node:
	get: return active_scene;
	set(new_scene):
		if !new_scene:
			return;
		if active_scene:
			active_scene.visible = false;
			scene_exited.emit(active_scene);
			if active_scene.has_method("on_disable"):
				active_scene.on_enable();
		active_scene = new_scene;
		active_scene.visible = true;
		
		scene_entered.emit(active_scene);
		if active_scene.has_method("on_enable"):
			active_scene.on_enable();
			
func get_or_create_scene(scene_name: String):
	var scene_filtered := scenes.filter(func(scene): return scene.id == scene_name);
	if scene_filtered.size() == 1:
		var scene_info: SceneInfo = scene_filtered[0];
		print(scene_info.node_path)
		if !scene_info.node_path.is_empty():
			return get_node(scene_info.node_path);
		else:
			var node = scene_info.packed_scene.instantiate();
			add_child(node)
			scene_info.node_path = node.get_path();
			return node;
		
func set_active_scene(scene_name: String, remove_active_from_tree: bool = true, last_position: Node3D = null):
	if active_scene:
		if last_position:
			active_scene.set_meta("last_tile", last_position)
		if remove_active_from_tree:
			active_scene.queue_free()
	active_scene = get_or_create_scene(scene_name)
	
	if Manager.player:
		if active_scene.has_meta("last_tile"):
			Manager.player.current_tile = active_scene.get_meta("last_tile")
		else:
			Manager.player.current_tile = active_scene.entrance;                   

func _ready():
	set_active_scene("main_menu")
