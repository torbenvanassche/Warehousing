extends Node

var data_file_path: String = "res://imported_assets/item_data/item_database.json"
var _items: Dictionary = FileUtils.load_json(data_file_path);
	
func get_item(id: String):
	if _items.keys().find(id) != -1:
		var rv = _items[id];
		rv.id = id;
		return rv;
	printerr(id + " not found in the item database.")
	return null;
	
func get_by_property(prop: String, value: Variant, dict: Dictionary = _items) -> Dictionary:
	var a_items: Dictionary = {};
	for entry in dict.keys():
		if dict[entry].has(prop) && dict[entry][prop] == value:
			a_items[entry] = dict[entry];
			a_items[entry].id = entry;
	return a_items;

func get_scene(item: Dictionary) -> PackedScene:
	var path = "res://resources/items/scenes/" + item.scene_path
	if ResourceLoader.exists(path):
		return load(path)
	return null
	
func get_sprite(item: Dictionary) -> Texture:
	if item.has("sprite"):
		return item.sprite;
	else:
		var path = "res://resources/items/sprites/" + item.sprite_path + ".png"
		if ResourceLoader.exists(path):
			item.sprite = load(path);
			return item.sprite;
		return null
	
func assign_layout(source: Dictionary, destination: Dictionary) -> void:
	var result: Array[bool] = []
	if source.has("layout") && source.layout is Dictionary:
		for c in source.layout.data:
			result.append(bool(int(c)))
	else:
		result.append(true);
		
	if source.layout is Dictionary:
		destination.layout_cols = source.layout.columns;
		destination.layout = result;
	
func get_colors(item: Dictionary) -> Array[Color]:
	var colors: Array = item.colors;
	var output: Array[Color] = []
	for c in colors:
		output.append(Color(c));
	return output;
	
func get_components(item: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for component in item.components:
		result.append(get_item(component))
	return result
	
func get_craftables(components: Array[String], process: Utils.CRAFT_METHOD):
	var options = get_by_property("process", Utils.convert_craft_method(process), get_by_property("available", true));
	options = get_by_property("components", components, options)
	return options;
