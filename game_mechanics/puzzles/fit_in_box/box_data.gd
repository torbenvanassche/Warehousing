class_name BoxData
extends Resource

#stores the state of the inventory as a 2d grid of booleans
var inventory_2d: Array[Array] = []

#stores a list of items in the grid with their respective counts
var item_list: Array[String];

#stores the items in the grid with their location
var _items: Array = [];	

func get_tile(btn_index: int, erase: bool = false):	
	var clicked_shape = []
	for item_shape in _items:
		for tile in item_shape:
			if tile.index == btn_index:
				clicked_shape = item_shape;
	if erase && clicked_shape.size() > 0:
		_items.erase(clicked_shape)
		item_list.erase(clicked_shape[0].key)
	return clicked_shape;	

func intersect(item, chosen_position: Vector2i) -> Array:
	var result = [];
	for row_idx in item.size():
		var row = item[row_idx]
		for col_idx in row.size():
			if row_idx+chosen_position.y >= inventory_2d.size() || col_idx+chosen_position.x >= row.size():
				return [];
			
			var item_state: bool = row[col_idx]
			if row_idx+chosen_position.x >= inventory_2d.size() || col_idx+chosen_position.y >= inventory_2d[row_idx+chosen_position.x].size():
				return [];
			elif inventory_2d[row_idx+chosen_position.y][col_idx+chosen_position.x] and item_state:
				return [];
			elif item_state:
				result.append(Vector2i(row_idx+chosen_position.x, col_idx+chosen_position.y))
	return result;
	
func add_item(item_data: Array):
	item_list.append(item_data[0].key)
	_items.append(item_data);
	
func set_tile(x:int, y: int, value: bool):
	inventory_2d[x][y] = value;
	
func clear():
	inventory_2d.clear();
	item_list.clear();
	_items.clear();
