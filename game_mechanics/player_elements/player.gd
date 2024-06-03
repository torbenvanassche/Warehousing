class_name Player
extends CharacterBody3D

@onready var inventory: Inventory = $Inventory;
@onready var animator: AnimationPlayer = $AnimationPlayer;
@onready var speech_bubble: EmoteHandler = $mesh/SpeechBubble;

@export var move_delay: float = 0.5;
@export var rotation_time: float = 0.01;
@export var animation_delay: float = 0.2;
@export var move_speed: float = 3;

signal on_move_complete(tile: TileBase);

var move_tween: Tween;
var is_moving := false;
var buffered_target_tile: TileBase

func _ready():
	Manager.player = self;
	animator.speed_scale = (1 / (move_delay + animation_delay));
	
	inventory.on_item_add_failed.connect(speech_bubble.set_emote.bind(speech_bubble.get_emote_by_id("CROSS").frame))
	
func set_speed(speed: float):
	move_delay = speed;
	animator.speed_scale = (1 / (move_delay + animation_delay));
	
func is_near(node: Node3D, max_distance: float = 1) -> bool:
	return global_position.distance_to(node.global_position) <= max_distance;
