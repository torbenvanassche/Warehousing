extends Node

var items: Dictionary;

signal item_generated();

func _ready():
	items = ItemManager.get_items();
	print(items)
