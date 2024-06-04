class_name Player
extends CharacterBody3D

@onready var inventory: Inventory = $Inventory;
@onready var animator: AnimationPlayer = $AnimationPlayer;
@onready var speech_bubble: EmoteHandler = $mesh/SpeechBubble;
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D;

@export var move_delay: float = 0.5;
@export var rotation_time: float = 0.1;
@export var animation_delay: float = 0.2;
@export var move_speed: float = 3;

var use_navmesh: bool = false;

signal on_move_complete();

func _ready():
	Manager.player = self;
	animator.speed_scale = (1 / (move_delay + animation_delay));
	inventory.on_item_add_failed.connect(speech_bubble.set_emote.bind(speech_bubble.get_emote_by_id("CROSS").frame))
	
func set_speed(speed: float):
	move_delay = speed;
	animator.speed_scale = (1 / (move_delay + animation_delay));
	
func is_near(node: Node3D, max_distance: float = 1) -> bool:
	return global_position.distance_to(node.global_position) <= max_distance;
	
func get_closest_point_navmesh(position: Vector3) -> Vector3:
	return NavigationServer3D.map_get_closest_point(NavigationServer3D.agent_get_map(navigation_agent.get_rid()), position)
	
func look_forward(position: Vector3 = velocity):
	if global_position.distance_to(transform.origin + position) > 0.25:
		look_at(transform.origin + velocity, Vector3.UP)
