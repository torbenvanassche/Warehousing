extends InventoryUI

var window: DraggableControl;

@onready var infoTitle: Label = $"../MarginContainer/VBoxContainer/Title";
@onready var infoDetails: Label = $"../MarginContainer/VBoxContainer/Description";

func add(dict: ItemSlot):
	var item_ui = super(dict)
	item_ui.mouse_entered.connect(set_info_content.bind(item_ui))
	item_ui.mouse_exited.connect(set_info_content)
	
func on_enable(_options: Dictionary = {}):
	super(_options)
	window.change_title.emit("Inventory");

func set_info_content(slot: ItemSlotUI = null):
	if selected_slot:
		slot = selected_slot;
		
	if slot && slot.slot_data && slot.slot_data.item != {}:
		infoTitle.text = slot.slot_data.item.name;
		infoDetails.text = slot.slot_data.item.description;
	else:
		infoTitle.text = "";
		infoDetails.text = "";
