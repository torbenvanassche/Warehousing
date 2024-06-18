extends Node

@onready var item_image: TextureRect = $HBoxContainer/item_image;
@onready var item_name: Label = $HBoxContainer/item_name;
@onready var item_shape: GridContainer = $MarginContainer/HBoxContainer2/VBoxContainer/ItemShape;
@onready var item_description_container: ScrollContainer = $MarginContainer/HBoxContainer2/MarginContainer/ScrollContainer;

func on_enable(dict: Dictionary = {}) -> void:
	var item = ItemManager.get_item("wheat")
	
	item_image.texture = ItemManager.get_sprite(item)
	item_name.text = item.name;
	item_shape.columns = item.layout_cols;
	
	for c in item_shape.get_children():
		c.queue_free()
	
	for n in item.layout.size():
		var color_rect = ColorRect.new();
		color_rect.color = Color.WHITE if n else Color.TRANSPARENT;
		color_rect.custom_minimum_size = Vector2(50, 50);
		item_shape.add_child(color_rect)
