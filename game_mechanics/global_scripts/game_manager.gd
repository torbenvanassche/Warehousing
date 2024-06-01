extends Node3D

@export var scenes: Array[Node]
@export var initial_scene: Node
@export var player: Player
var camera: Camera3D;
	
func pause(pause_game = true):
	get_tree().paused = pause_game

func get_scene_by_name(scene_name: String):
	var filtered = scenes.filter(func(x: Node): return x.name == scene_name)
	if filtered.size() > 0:
		return filtered[0]
	else:
		return null
	
	for s in scenes:
		if s != initial_scene:
			s.visible = false;
