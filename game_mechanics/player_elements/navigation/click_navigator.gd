class_name ClickNavigator
extends Node

var destination_tile: TileBase = null

var on_tile_destination_reached: Callable = Callable();
var target: Player;
	
func _ready():
	target = self.get_parent();
