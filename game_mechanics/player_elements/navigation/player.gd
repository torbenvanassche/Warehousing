class_name Player
extends Node3D

var current_tile: TileBase = null: 
	set(value):
		current_tile = value;
		set_position_to_current_tile()

@export var inventory: Inventory;
@export var animator: AnimationPlayer;
@export var speech_bubble: EmoteHandler;

@export var click_navigator: ClickNavigator;
@export var wasd_navigator: DefaultNavigator;

@export var move_delay: float = 0.5;
@export var rotation_time: float = 0.01;
@export var animation_delay: float = 0.2;

signal on_move_complete(tile: TileBase);

var move_tween: Tween;
var is_moving := false;
var buffered_target_tile: TileBase

func _ready():
	Manager.player = self
	animator.speed_scale = (1 / (move_delay + animation_delay));
	Settings.input_mode_changed.connect(read_input_mode)
	
	inventory.on_item_add_failed.connect(speech_bubble.set_emote.bind(speech_bubble.get_emote_by_id("CROSS").frame))
	
	current_tile = find_location();
	
func set_speed(speed: float):
	move_delay = speed;
	animator.speed_scale = (1 / (move_delay + animation_delay));
	
func read_input_mode(nav: Settings.NAV_STYLE):
	match nav:
		Settings.NAV_STYLE.CLICK:
			wasd_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			click_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
		Settings.NAV_STYLE.WASD:
			click_navigator.process_mode = Node.PROCESS_MODE_DISABLED;
			wasd_navigator.process_mode = Node.PROCESS_MODE_INHERIT;
	
func move(): 
	if buffered_target_tile:
		is_moving = false
		try_move(buffered_target_tile)
		return
	
	if  PathFinder.current_nav.size() < 1 and not buffered_target_tile:
		is_moving = false
		return
	
	_move_next()
	
func _move_next():
	if !animator.is_playing():
		animator.play("hop");
	
	is_moving = true
	var next_target = PathFinder.current_nav.pop_front()
	move_tween = get_tree().create_tween();
	move_tween.tween_property(self.get_parent(), "global_position", next_target.surface_point, move_delay).set_trans(Tween.TRANS_QUAD).set_delay(0.05);
	move_tween.parallel().tween_method(look_at.bind(Vector3.UP), global_transform.origin, next_target.surface_point, rotation_time)
	move_tween.finished.connect(_update_current_tile.bind(next_target))
	move_tween.finished.connect(func(): on_move_complete.emit(next_target))
	move_tween.finished.connect(animator.stop)
	move_tween.finished.connect(move)

func _update_current_tile(new_tile:TileBase):
	current_tile = new_tile

func try_move(tile: TileBase) -> bool:
	buffered_target_tile = tile
	var path = PathFinder.get_valid_path(current_tile, tile);
	if path.size() != 0:
		if !is_moving:
			buffered_target_tile = null
			PathFinder.set_path(path);
			move()
		return true;
	return false;
		
func _set_to_index(idx: int = -1):
	if idx > 0:
		idx = (int)(float(idx) / 2);
	current_tile = PathFinder.current_nav[idx]

func set_position_to_current_tile(tile: TileBase = current_tile):
	if !tile:
		print("No tile found to set position to, skipping...")
		return
	
	tile.find_surface()
	get_parent().global_position = current_tile.surface_point
	
func find_location() -> TileBase:
	var space_state = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(global_position  + Vector3(0, 1, 0), global_position - Vector3(0, 2, 0))
	
	var result = space_state.intersect_ray(q)
	
	if result:
		return result.collider.get_parent() as TileBase
		
	return null
	
func is_near(node: Node3D, max_distance: float = 1) -> bool:
	return global_position.distance_to(node.global_position) <= max_distance;
