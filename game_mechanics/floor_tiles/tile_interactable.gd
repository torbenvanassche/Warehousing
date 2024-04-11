class_name TileInteractable
extends TileBase

@export var interaction: Node;

func _ready():
	super();
	self.input_event.connect(execute)
	PathFinder.add_node(self)

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if Input.is_action_just_pressed("mouse_left"):
		if !Manager.player.try_move(self) && Manager.player.is_adjacent(self):
			on_move_complete()
		
func on_move_complete():
	if interaction && interaction.has_method("execute"):
		interaction.execute({"player": Manager.player});
	else:
		print("interaction on " + self.name + " is not set.")
