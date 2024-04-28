extends Node

@onready var spawner: ItemSpawner = $".";
@export var max_item_buffer: int = 1;
var spawned_item_buffer: Inventory

@export var spawn_locations: Array[Node3D] = [];

func _ready():
	spawned_item_buffer = Inventory.new(max_item_buffer, max_item_buffer, "Input buffer");
	spawner.item_generated.connect(_on_signal)
	
func _on_signal(item: Dictionary):
	if spawned_item_buffer.add_item(item, 1, false, true) == 0:
		var rnd_location = handle_random_location();
		#TODO: instantiate the mesh of the item
		pass
		
#this code prevents taking locations that are already in use
func handle_random_location():
	var rnd_location = spawn_locations.filter(func(x): return x.has_meta("taken") && x.get_meta("taken", false)).pick_random();
	rnd_location.set_meta("taken", true);
	return rnd_location;
