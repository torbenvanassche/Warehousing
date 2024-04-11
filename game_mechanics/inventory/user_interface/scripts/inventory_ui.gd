class_name InventoryUI
extends Control

@export var item_slot_script: Script;

var item_ui_packed: PackedScene = preload("res://game_mechanics/inventory/user_interface/slot_ui.tscn");              
var elements: Array[ItemSlotUI] = []

var selected_slot: ItemSlotUI;
var controller: Inventory;
var window: DraggableControl;
var btn_grp: ButtonGroup = ButtonGroup.new()

@export var show_locked: bool = false;
@export var visual_element: Control = self;

@onready var infoTitle: Label = $"../VBoxContainer/InfoView/MarginContainer/HBoxContainer/Label";
@onready var infoTexture: TextureRect = $"../VBoxContainer/InfoView/MarginContainer/HBoxContainer/TextureRect";
@onready var infoDetails: Label = $"../VBoxContainer/InfoView/TextMargin/Label";

func set_controller(con: Inventory):
	if con != controller:
		if controller: 
			controller.inventory_changed.disconnect(_update)
		controller = con;
	if !controller.inventory_changed.is_connected(_update):
		controller.inventory_changed.connect(_update);
	create_ui(controller.data)
	controller.refresh_ui();
	
func create_ui(data: Array[ItemSlot]):
	for d in data:
		add(d)

func add(dict: ItemSlot):
	var item_ui = item_ui_packed.instantiate() as ItemSlotUI;
	item_ui.set_script(item_slot_script)
	visual_element.add_child(item_ui);
	elements.append(item_ui);
	
	item_ui.mouse_entered.connect(set_info_content.bind(item_ui))
	item_ui.mouse_exited.connect(set_info_content)
	item_ui.button_up.connect(_set_selected.bind(item_ui))
	item_ui.on_drag_end.connect(func(_drag_end_slot): selected_slot = null);
	item_ui.button_group = btn_grp;
	
	if show_locked:
		item_ui.disabled = !dict.is_available;
	else:
		item_ui.visible = dict.is_available;
	item_ui.set_reference(dict);
	
func set_info_content(slot: ItemSlotUI = null):
	if selected_slot:
		slot = selected_slot;
		
	if slot && slot.slot_data && slot.slot_data.item != {}:
		infoTitle.text = slot.slot_data.item.name;
		infoDetails.text = slot.slot_data.item.description;
		infoTexture.texture = slot.slot_data.item.sprite;
	else:
		infoTitle.text = "";
		infoDetails.text = "";
		infoTexture.texture = null;
	
func _set_selected(slot: ItemSlotUI):
	if selected_slot != slot && selected_slot:
		selected_slot.button_pressed = false;
		selected_slot = null;
	
	var redraw = selected_slot == slot;
	if redraw || (slot && slot.slot_data.item == {}):
		slot.button_pressed = false;
		selected_slot = null;
		if !redraw:
			set_info_content()
	else:
		selected_slot = slot;

func _clear():
	for e in elements:
		e.queue_free();
	elements.clear();
	
func _update(data: Array[ItemSlot]):
	_clear();
	for index in range(data.size()):
		add(data[index])
		
func on_enable(options: Dictionary = {}):
	if !item_ui_packed:
		printerr("the item's UI is undefined")
		return;
	set_controller(Manager.player.inventory);
	window.change_title.emit("Inventory");
	btn_grp.allow_unpress = true;
