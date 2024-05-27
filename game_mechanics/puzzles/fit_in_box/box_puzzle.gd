class_name FittingPuzzle
extends GridContainer

@export var item_slot_script: Script 
@onready var container: BoxData = BoxData.new();
var item_ui_packed: PackedScene = preload("res://game_mechanics/inventory/user_interface/slot_ui.tscn");  
var window: DraggableControl;

signal item_added(id: String);
signal item_removed(id: String);

@export var visual_element: Control = self
var clear_on_open: bool = true;

func on_enable(_dict: Dictionary = {}):
	if clear_on_open:
		#clear_on_open = false;
		container.clear();
		for child in visual_element.get_children():
			child.queue_free();
			
	if !_dict.has("carryable") || !(_dict["carryable"] is Carryable):
		printerr("The dictionary for the puzzle does not contain a carryable object.");
		return;
	
	visual_element.columns = _dict.carryable.size.y;
	var curr_arr: Array = []
	
	for i in range(_dict.carryable.size.x * _dict.carryable.size.y):
		var btn = item_ui_packed.instantiate() as ItemSlotUI;
		btn.set_script(item_slot_script);
		btn.puzzle_controller = self;
		visual_element.add_child(btn)
		
		btn.set_reference.call_deferred(ItemSlot.new(true, "Puzzle"))
		btn.custom_minimum_size = Vector2(25, 25);
		btn.show_amount = false;
		
		curr_arr.append(false)
		if i % visual_element.columns == visual_element.columns - 1:
			container.inventory_2d.append(curr_arr.duplicate());
			curr_arr.clear();
	
func _ready():
	if !visual_element:
		visual_element = self;
	_deferred_ready.call_deferred();
	resized.connect(_control_size)
	
func _control_size():
	for e: Control in get_children():
		var container_size_x = clamp((size.x / columns) - get_theme_constant("h_separation"), 50, 100);
		e.custom_minimum_size.x = container_size_x;
		e.custom_minimum_size.y = container_size_x;
	
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
