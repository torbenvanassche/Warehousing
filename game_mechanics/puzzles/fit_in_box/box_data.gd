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
	var item_height = item.size()
	var item_width = item[0].size()
	var grid_height = inventory_2d.size()
	var grid_width = inventory_2d[0].size()

	# Unpack the chosen position
	var x = chosen_position.x
	var y = chosen_position.y
	
	var positions = []

	# Check if the item fits within the grid dimensions starting from (x, y)
	if x + item_height > grid_height or y + item_width > grid_width:
		return []

	# Check each cell of the item
	for i in range(item_height):
		for j in range(item_width):
			if item[i][j]:  # Only check cells that are True in the item
				if inventory_2d[x + i][y + j]:  # Check if the corresponding cell in the grid is already occupied
					return []
				positions.append(Vector2(x + i, y + j))

	# If all checks pass, the item can be placed
	return positions
	
func add_item(item_data: Array):
	item_list.append(item_data[0].key)
	_items.append(item_data);
	
func set_tile(x:int, y: int, value: bool):
	inventory_2d[y][x] = value;
	
func clear():
	inventory_2d.clear();
	item_list.clear();
	_items.clear();
