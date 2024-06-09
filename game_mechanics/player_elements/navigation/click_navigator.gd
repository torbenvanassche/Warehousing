class_name ClickNavigator
extends Node

var destination: Vector3:
	set(value):
		destination = value;
		player.navigation_agent.target_position = value;
		
@onready var player: Player = get_parent();
var arrived: bool = false;

func _ready():
	call_deferred("_defer_ready")
	
func _defer_ready():
	player.navigation_agent.target_reached.connect(func(): arrived = true);
	player.navigation_agent.path_changed.connect(func(): arrived = false);
	
func _physics_process(_delta):
	if !player.use_navmesh:
		return
	var current_location = player.global_position;
	var next_location = player.navigation_agent.get_next_path_position();
	var new_velocity = (next_location - current_location).normalized() * player.move_speed;
	player.velocity = new_velocity;
	player.move_and_slide();
	if player.velocity != Vector3.ZERO && !arrived:
		player.look_forward(next_location)
	
func _input(event):
	if event is InputEventMouseButton and event.is_released() and event.button_index == 1:
		if UserInterface.instance.is_ui_closed():
			return
		
		player.use_navmesh = true;
		var space_state = player.get_world_3d().direct_space_state;
		
		var origin = Manager.camera.project_ray_origin(event.position)
		var end = origin + Manager.camera.project_ray_normal(event.position) * 1000;
		var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(origin, end))
		if result != {}:
			destination = player.get_closest_point_navmesh(result.position);
		
