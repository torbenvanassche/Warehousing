extends Node

@onready var spawner: ItemSpawner = $"./../../";
var max_item_buffer: int = 1;
var spawned_item_buffer: Inventory
var spawn_locations: Array[Node3D] = [];

func _ready():
	spawned_item_buffer = Inventory.new(max_item_buffer, max_item_buffer, "Input buffer");
	spawner.item_generated.connect(_on_signal)
	spawn_locations.append_array(get_children())
	max_item_buffer = get_child_count();
	
	if spawn_locations.size() == 0:
		printerr(self.name + " has no children, no elements can be spawned on this.")
	
func _on_signal(item: Dictionary):
	if spawned_item_buffer.add_item(item, 1, false, true) == 0:
		var rnd_location: Node3D = handle_random_location();
		var instance: Node3D = ItemManager.get_scene(item).instantiate();
		rnd_location.add_child(instance)
		pass
		
#this code prevents taking locations that are already in use
func handle_random_location():
	var rnd_location = spawn_locations.filter(func(x): return !x.get_meta("taken", false)).pick_random();
	if !rnd_location:
		printerr("No free slot found to generate an item into, skipping!")
		return;
	rnd_location.set_meta("taken", true);
	return rnd_location;
