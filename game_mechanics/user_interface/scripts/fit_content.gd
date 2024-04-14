extends GridContainer

@export var element_preset: PackedScene;
@export var amount: int = 20;

func _ready():
	var single_size = size.x / columns	
	print(single_size)
