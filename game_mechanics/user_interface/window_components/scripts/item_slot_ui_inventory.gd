class_name InventoryItemSlotUI
extends ItemSlotUI

signal on_drag_end(b: ItemSlotUI);

func _get_drag_data(_at_position):
	if slot_data.item != {}:
		as_blank();
		return DragData.new(slot_data.item, "inventory", [], [self]);
	return null;
	
func _can_drop_data(_at_position, data):
	var data_is_valid = data is DragData && self is ItemSlotUI && slot_data.is_available;
	var can_place_item = slot_data.has_space(data.item.id, data.item.count);
	return data_is_valid && can_place_item;
	
func _drop_data(_at_position, data):
	var count_removed = data.item.count;
	data.item_slots[0].slot_data.remove(data.item.count);
	if data.origin_window == "puzzle":
		(data.item_slots[0].puzzle_controller as FittingPuzzle).reset_tiles(data.item_slots[0])
		slot_data.add(data.item, 1);
	else:
		slot_data.add(data.item, count_removed);
	on_drag_end.emit(self)
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful():
				on_drag_end.emit(self)
				redraw()
				
func _gui_input(_event):
	if _event is InputEventMouseButton and _event.is_pressed() and _event.button_index == MOUSE_BUTTON_RIGHT && !slot_data.is_empty() && slot_data.item.count > 1:
		var mouse_position = get_global_mouse_position();
		var context := ContextMenu.new([
			ContextMenuItem.new("Split stack", UserInterface.instance.enable_ui.bind(UserInterface.instance.get_subwindow("SPLITSTACK"), true, {"slot": self}), Manager.player.inventory.has_open_slot())
			])
		context.open(Rect2(mouse_position.x, mouse_position.y, context.size.x, context.size.y))
	pass
