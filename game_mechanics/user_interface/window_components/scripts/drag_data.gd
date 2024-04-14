class_name DragData
extends Node

var item: Dictionary;
var item_slots: Array[ItemSlotUI];
var origin_window: String;

func _init(it: Dictionary, window: String, slots: Array[ItemSlotUI] = []):
	item = it;
	item_slots = slots;
	origin_window = window;
