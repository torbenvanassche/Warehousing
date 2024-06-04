class_name DefaultNavigator
extends Node

var input_checks: Array[String] = ["move_left", "move_right", "move_back", "move_forward"];
var can_move: bool = true;

var input: Vector2;
@onready var player: Player = get_parent();

func _process(_delta):
	if(can_move):
		input = Input.get_vector(input_checks[0], input_checks[1], input_checks[2], input_checks[3]);
		
func _physics_process(_delta):
	if input != Vector2.ZERO:
		player.use_navmesh = false;
		var cam_relative = (Manager.camera.global_basis * Vector3(input.x, 0, -input.y)).normalized()
		cam_relative.y = 0;
		
		player.velocity = cam_relative * player.move_speed;
		player.move_and_slide();
		player.look_forward()
