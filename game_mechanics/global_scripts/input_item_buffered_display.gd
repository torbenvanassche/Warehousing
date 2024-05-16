extends Node

@onready var spawner: ItemGenerator = $"./../";
var spawned_item_buffer: Inventory
var spawn_locations: Array[Node] = [];
@export var random_rotation: bool = false;

@export var item_interaction_script: Interaction;
@onready var interactable_script: Script = preload("res://game_mechanics/world_interactable/interactable.gd")

func _ready():
	spawn_locations = get_children().filter(func(x: Node3D): return !(x is MeshInstance3D));
	spawned_item_buffer = Inventory.new(spawn_locations.size(), spawn_locations.size(), "Input buffer");
	spawner.item_generated.connect(_on_signal)
	
	if spawn_locations.size() == 0:
		printerr(self.name + " has no children, no elements can be spawned on this.")
	
func _on_signal(item: Dictionary):
	if spawned_item_buffer.add_item(item, 1, false, true) == 0:
		var rnd_location: Node3D = handle_random_location();
		var instance: Node3D = ItemManager.get_scene(item).instantiate();
		instance.set_script(interactable_script)
		
		var interactable = instance as Interactable
		interactable.interaction = item_interaction_script;
		interactable.set_meta("item", item);
		rnd_location.add_child(instance);
		instance.tree_exiting.connect(_on_item_deleted.bind(instance))
		
		if random_rotation:
			instance.rotate_y(deg_to_rad(randi_range(-180, 180)))
			
func _on_item_deleted(node: Node):
	spawned_item_buffer.remove_item(node.get_meta("item"))
	node.get_parent().remove_meta("taken");
		
#this code prevents taking locations that are already in use
func handle_random_location():
	var rnd_location = spawn_locations.filter(func(x): return !x.get_meta("taken", false)).pick_random();
	if !rnd_location:
		printerr("No free slot found to generate an item into, skipping!")
		return;
	rnd_location.set_meta("taken", true);
	return rnd_location;
