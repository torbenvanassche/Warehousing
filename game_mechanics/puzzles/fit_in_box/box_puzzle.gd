class_name FittingPuzzle
extends Control

@export var item_slot_script: Script 
@onready var container: BoxData = BoxData.new();
var item_ui_packed: PackedScene = preload("res://game_mechanics/inventory/user_interface/slot_ui.tscn");  
var window: DraggableControl;

signal item_added(id: String);
signal item_removed(id: String);

@export var visual_element: Control = self
var clear_on_open: bool = true;

func on_enable(dict: Dictionary = {}):
	if clear_on_open:
		#clear_on_open = false;
		container.clear();
		for child in visual_element.get_children():
			child.queue_free();
	
	visual_element.columns = Manager.player.carryable.size;
	var curr_arr: Array = []
	
	for i in range(Manager.player.carryable.size.x * Manager.player.carryable.size.y):
		var btn = item_ui_packed.instantiate() as ItemSlotUI;
		btn.set_script(item_slot_script);
		btn.puzzle_controller = self;
		btn.set_reference(ItemSlot.new(true, "Puzzle"));
		#TODO: Make width dynamic to fit into the container
		btn.custom_minimum_size = Vector2(25, 25);
		btn.show_amount = false;
		visual_element.add_child(btn)
		
		curr_arr.append(false)
		if i % visual_element.columns == visual_element.columns - 1:
			container.inventory_2d.append(curr_arr.duplicate());
			curr_arr.clear();
	
func _ready():
	if !visual_element:
		visual_element = self;
	_deferred_ready.call_deferred();
	
func _deferred_ready():
	window.close_requested.connect(hide)
	
func can_add(btn: ItemSlotUI, item: Dictionary) -> Array:
	item = item.duplicate();
	var btn_index = visual_element.get_children().find(btn)
	var item_shape = Utils.convert_array_to_array2D(item.layout, item.layout_cols)
	item.count = 1;

	var intersections = container.intersect(item_shape, Vector2i(int(btn_index / float(visual_element.columns)), btn_index % visual_element.columns));
	return intersections;	

func add_item(btn: ItemSlotUI, item: Dictionary) -> void:
	var intersections = can_add(btn, item);
	var item_connections = [];

	if intersections.size() > 0:
		for intersection in intersections:
			item_connections.append({"x": intersection.y, "y": intersection.x, "key": item.id, "index": intersection.x * visual_element.columns + intersection.y})
			var ui_item = (visual_element.get_children()[intersection.x * visual_element.columns + intersection.y] as ItemSlotUI);
			ui_item.slot_data.add(item, item.count)
			container.set_tile(intersection.y, intersection.x, true)
			btn.redraw()
		container.add_item(item_connections);
		item_added.emit(item.id)
		
func get_shape(btn: ItemSlotUI, erase: bool = true):
	return container.get_tile(visual_element.get_children().find(btn), erase)
	
func get_slot(idx: int) -> ItemSlotUI:
	return visual_element.get_child(idx);

func reset_tiles(btn: ItemSlotUI):
	var clicked_shape = get_shape(btn, true)
	for tile in clicked_shape:
		container.set_tile(tile.x, tile.y, false);
		visual_element.get_child(tile.index).slot_data.remove_all();
