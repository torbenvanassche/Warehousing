extends Node

var current_nav = []
var tiles_storage: Array[TileBase] = []
var a_star = AStar2D.new()	
var max_distance = 1.1;

var registered_interaction: Callable = Callable();

func _init():
	generate.call_deferred()
	
func add_node(tile: TileBase, update_navigation = false):
	if(!tiles_storage.has(tile)):
		tiles_storage.append(tile);
		
		if(update_navigation):
			generate();
		
func remove_node(tile: TileBase, update_navigation = false):
	if(tiles_storage.has(tile)):
		tiles_storage.erase(tile);
		
	if(update_navigation):
		generate();	
		
func generate():
	set_neighbours();
	generate_connections();	
		
func set_tiles(tileArr: Array[TileBase]):
	tiles_storage = tileArr;
	
func clear_connections():
	for tile in tiles_storage:
		tile.neighbours.clear()
		
func clear(delete_tiles: bool):
	a_star.clear()
	clear_connections();
	
	if delete_tiles:
		for tile in tiles_storage:
			tile.queue_free()
		
	
func get_random_tile(): 
	return tiles_storage[randi_range(0, tiles_storage.size() - 1)]
	
func set_neighbours(distance: float = max_distance):
	max_distance = distance;
	for current_tile in tiles_storage:
		for potential_neighbour in tiles_storage:
			if current_tile != potential_neighbour:
				var dist = Vector3(current_tile.global_position.x, current_tile.global_position.y, current_tile.global_position.z).distance_squared_to(Vector3(potential_neighbour.global_position.x, potential_neighbour.global_position.y, potential_neighbour.global_position.z))
				if dist < max_distance:
					if !current_tile.neighbours.has(potential_neighbour):
						current_tile._add_neighbour(potential_neighbour)
					
func generate_connections():
	for tile in tiles_storage:
		if tile.walkable_in_scene:
			tile.path_index = a_star.get_point_count()		
			a_star.add_point(tile.path_index, Vector2(tile.global_position.x, tile.global_position.z), tile.navigation_weight)
		
	for tile in tiles_storage:
		for connected_tile in tile.neighbours:
			if connected_tile.walkable_in_scene && tile.walkable_in_scene && !tile.exclusions.has(connected_tile):
				a_star.connect_points(tile.path_index, connected_tile.path_index)
			
func repath():
	if current_nav.size() != 0:
		calc_path(Manager.player.current_tile.path_index, current_nav[current_nav.size() - 1].path_index)

func calc_path(from: int, to: int):	
	current_nav.clear()
	
	for t in a_star.get_id_path(from, to):
		current_nav.append(tiles_storage.filter(func(x): return x.path_index == t)[0])
	current_nav.pop_front()
	
func get_valid_path(start: TileBase, end: TileBase) -> Array[TileBase]:
	var closest_path: PackedInt64Array = []
	if end.walkable_in_scene:
		var path_ids = a_star.get_id_path(start.path_index, end.path_index);
		closest_path = path_ids;
	else:
		for n in end.neighbours:
			if n.walkable_in_scene:
				var path = a_star.get_id_path(start.path_index, n.path_index);
				if path.size() < closest_path.size() || closest_path.size() == 0:
					closest_path = path;
						
	if closest_path.size() > 0 && end.has_method("on_move_complete"):
		registered_interaction = Callable(end, "on_move_complete");
	else:
		registered_interaction = Callable();
	
	return _indices_to_tiles(closest_path);
	
func _indices_to_tiles(arr: PackedInt64Array) -> Array[TileBase]:
	var path: Array[TileBase] = []
	
	for t in arr:
		path.append(tiles_storage.filter(func(x): return x.path_index == t)[0])
	path.pop_front()
	return path;
	
func set_path(arr: Array[TileBase]):
	current_nav = arr;
