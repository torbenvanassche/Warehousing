class_name InteractionPickup
extends Interaction

func execute(_dict: Dictionary = {}):
	Manager.player.inventory.add_item(_dict.target.get_meta("item"))
	_dict.target.queue_free();
