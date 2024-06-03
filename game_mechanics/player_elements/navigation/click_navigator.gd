class_name ClickNavigator
extends Node

@onready var navigation_agent: NavigationAgent3D = $"../NavigationAgent3D";

var destination: Vector3:
	set(value):
		destination = value;
		navigation_agent.target_position = value;
		
var player: Player;
	
func _ready():
	player = self.get_parent();
	navigation_agent.target_reached.connect(func(): destination = player.global_position)
	
func _physics_process(delta):
	var current_location = player.global_position;
	var next_location = navigation_agent.get_next_path_position();
	var new_velocity = (next_location - current_location).normalized() * player.move_speed;
	player.velocity = new_velocity;
	player.move_and_slide();
	
func _input(event):
	if event is InputEventMouseButton and event.is_released() and event.button_index == 1:
		var space_state = player.get_world_3d().direct_space_state;
		
		var origin = Manager.camera.project_ray_origin(event.position)
		var end = origin + Manager.camera.project_ray_normal(event.position) * 1000;
		var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(origin, end))

		destination = NavigationServer3D.map_get_closest_point(NavigationServer3D.agent_get_map(navigation_agent.get_rid()), result.position)
