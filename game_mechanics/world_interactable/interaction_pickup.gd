class_name InteractionPickup
extends Interaction

func execute(_dict: Dictionary = {}):
	print(_dict.target.get_meta("item").name)
