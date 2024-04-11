extends TileBase

@export var player_can_stop: bool = true;
var static_body: StaticBody3D;

func _ready():
	super();
	
	var valid_children = Utils.flatten_hierarchy(self).filter(func(x): return x is StaticBody3D);
	if valid_children.size() == 1:
		static_body = valid_children[0];
	
	if player_can_stop:
		static_body.input_event.connect(execute)
	PathFinder.add_node(self)

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	if Input.is_action_just_pressed("primary_click") && self != Manager.player.current_tile && Settings.input_mode == Settings.NAV_STYLE.CLICK:
		Manager.player.try_move(self)
