extends Node3D

@export var scenes: Array[Node]
@export var initial_scene: Node
@export var player: Player
var camera: CameraController;

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
		
func set_active_scene(scene: Node, remove_active_from_tree: bool = true, last_position: Node3D = null):
	if active_scene && remove_active_from_tree:
		if last_position:
			active_scene.set_meta("last_tile", last_position)
	active_scene = scene
		
	if active_scene.has_meta("last_tile"):
		player.current_tile = active_scene.get_meta("last_tile")
	else:
		player.current_tile = active_scene.entrance;                   

func get_active_scene():
	return active_scene
	
func pause(pause_game = true):
	get_tree().paused = pause_game

func get_scene_by_name(scene_name: String):
	var filtered = scenes.filter(func(x: Node): return x.name == scene_name)
	if filtered.size() > 0:
		return filtered[0]
	else:
		return null
		
func _ready():
	active_scene = get_tree().root.get_node("GameScene/PostOffice")

	if active_scene.has_method("on_enable"):
		active_scene.on_enable();
	
	for s in scenes:
		if s != initial_scene:
			s.visible = false;
