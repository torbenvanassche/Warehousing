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
		return DragData.new(slot_data.item, "puzzle", shape, slots)
	
func _can_drop_data(_at_position, data):
	var is_drag_data = data is DragData && self is ItemSlotUI;
	return is_drag_data && slot_data.is_available && puzzle_controller.can_add(self, data.item).size() != 0;
	
func _drop_data(_at_position, data):
	puzzle_controller.add_item(self, data.item);
	for slot in data.item_slots:
		slot.slot_data.remove(1);
	puzzle_controller.reset_tiles(data.item_slots[0])
	on_drag_end.emit(self);
	
func _notification(what):
	match what:
		NOTIFICATION_DRAG_END:
			if !is_drag_successful():
				on_drag_end.emit(self)
				redraw()
