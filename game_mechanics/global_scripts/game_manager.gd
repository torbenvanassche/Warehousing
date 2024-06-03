extends Node3D

@export var scenes: Array[Node]
@export var player: Player
@export var navigation_region: NavigationRegion3D;
var camera: Camera3D;
	
func pause(pause_game = true):
	get_tree().paused = pause_game
