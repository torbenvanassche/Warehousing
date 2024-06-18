extends Node3D

@export var scenes: Array[Node]
@export var player: Player
@export var navigation_region: NavigationRegion3D;
var camera: Camera3D;

var current_save_file: SaveFile;
var scroll_in_use: bool = false;
	
func pause(pause_game = true):
	get_tree().paused = pause_game
