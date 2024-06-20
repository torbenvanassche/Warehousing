class_name InteractionPickup
extends Interaction

func execute(_dict: Dictionary = {}):
	if Manager.player.inventory.add_item(_dict.target.get_meta("item")) == 0: 
		_dict.target.queue_free();
