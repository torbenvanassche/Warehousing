class_name DefaultNavigator
extends Node

var input_checks: Array[String] = ["move_left", "move_right", "move_back", "move_forward"];
var can_move: bool = true;

@export var camera: Camera3D;

func _process(_delta):
	if(Utils.pressed_from_list(input_checks) && can_move):
		var velocity = Input.get_vector(input_checks[0], input_checks[1], input_checks[2], input_checks[3])
		if velocity != Vector2.ZERO:
			start_move(get_offset(velocity));
			
func get_offset(direction):
	var cam_relative = (camera.global_basis * Vector3(direction.x, 0, -direction.y)).normalized()
	if (abs(cam_relative.x) > abs(cam_relative.z)):
		return sign(cam_relative.x) * Vector3.RIGHT
	else:
		return sign(cam_relative.z) * Vector3.BACK

func start_move(moveVector: Vector3):
	var player = get_parent() as Player;
	var next_tile: TileBase = null;
	for tile in player.current_tile.neighbours:
		if (player.current_tile.surface_point + moveVector).distance_to(tile.surface_point) < 0.25:
			next_tile = tile;
			break;
	
	if next_tile:
		can_move = !player.try_move(next_tile)
		player.move_tween.finished.connect(func(): can_move = true);
