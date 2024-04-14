extends ItemSlotUI

signal on_drag_end(b: ItemSlotUI);
var puzzle_controller: FittingPuzzle;

func _get_drag_data(_at_position):
	var shape = puzzle_controller.get_shape(self, false)
	var slots: Array[ItemSlotUI] = [];
	for s in shape:
		var slot = puzzle_controller.get_slot(s.index);
		slots.append(slot);
		slot.as_blank();
		
	if slots.size() != 0:
		return DragData.new(slot_data.item, "puzzle", slots)
	
func _can_drop_data(_at_position, data):
	return data is DragData && self is ItemSlotUI && slot_data.is_available && puzzle_controller.can_add(self, data.item).size() != 0;
	
func _drop_data(_at_position, data):
	puzzle_controller.add_item(self, data.item);
	data.item_slots[0].slot_data.remove(1);
	on_drag_end.emit(self);
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful():
				on_drag_end.emit(self)
				redraw()
