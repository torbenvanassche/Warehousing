class_name ItemSpawner
extends Node

var items: Dictionary;
var timer: Timer = Timer.new();

@export var spawn_delay: float = 1;
@export var fail_weight: float = 0;

signal item_generated(dict: Dictionary);

func _ready():
	timer.wait_time = spawn_delay;
	timer.timeout.connect(_on_spawn)
	add_child(timer)
	timer.start();

func _on_spawn():
	var rnd_item = Utils.rand_item_weighted(ItemManager.get_items(), abs(fail_weight))
	if rnd_item != null:
		item_generated.emit(rnd_item)
