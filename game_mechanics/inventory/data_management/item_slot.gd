class_name ItemSlot;
extends Node;

var item: Dictionary = {}: 
	set(value):
		item = value;
		has_changed.emit();
	
var is_available = false;
var window_id: String = ""

signal has_changed();

func _init(available: bool = true, w_id: String = ""):
	is_available = available;
	window_id = w_id;
	
func is_empty():
	return !item;
	
func reset():
	item = {};
func has_space(id: String, amount: int = 1) -> bool:
	if !is_available:
		return false;	
	if item == {}:
		return true;
	elif item.id != id:
		return false;
		
	return item.stack_size - item.count - amount > 0;
	
func add(dict: Dictionary = item, amount: int = 1) -> int:
	if item == {}:
		item = dict.duplicate();
		item.count = 0;
	if dict.id == item.id:
		var remaining_space = item.stack_size - item.count
		var amount_to_add = min(amount, remaining_space)
		item.count += amount_to_add
		has_changed.emit();
		return amount - amount_to_add
	has_changed.emit();
	return amount;

func remove(amount: int = 1) -> int:
	if item == {}:
		return amount;
	var amount_to_remove = min(amount, item.count)
	item.count -= amount_to_remove
	if item.count <= 0:
		item = {}
	has_changed.emit();
	return amount - amount_to_remove

func remove_all():
	if item:
		remove(item.count)
