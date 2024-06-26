class_name ItemSlotUI
extends Button

@onready var textureRect: TextureRect = $MarginContainer/ItemSprite;
@onready var counter: Label = $MarginContainer/Count;
var slot_data: ItemSlot;

@export var default_color = Color(Color.WHITE)
@export var dragging_color = Color(Color.WHITE, 0.3);

@export var show_amount: bool = true:
	set(value):
		counter.visible = value;
		show_amount = value;
	
func as_blank():
	textureRect.modulate = dragging_color;
	counter.visible = false;
	
func redraw():
	var sprite = null;
	textureRect.modulate = default_color
	counter.visible = false;
	
	if slot_data.item.has("id"):
		sprite = ItemManager.get_sprite(slot_data.item);
		if !slot_data.item.has("count"):
			slot_data.item.count = 1;
		counter.set_text(str(slot_data.item.count));
		counter.visible = show_amount && slot_data.item.count > 0;
	textureRect.set_texture(sprite);
	
func set_reference(data: ItemSlot):
	if slot_data:
		slot_data.has_changed.disconnect(redraw);
	slot_data = data;
	slot_data.has_changed.connect(redraw);
	slot_data.has_changed.emit()
