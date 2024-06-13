class_name Utils
extends Node

enum CRAFT_METHOD { CRAFT, GRIND, ALCHEMY, FORGE }
static func convert_craft_method(value: int):
	return CRAFT_METHOD.keys()[value];

static func arrays_have_same_content(array1: Array, array2: Array):	
	if array1.size() != array2.size(): 
		return false
	for item in array1:
		if !array2.has(item): 
			return false
		if array1.count(item) != array2.count(item): 
			return false
	return true

static func rand_item_weighted(dict: Dictionary, fail_weight: int = 0):
	if dict.keys().size() == 0:
		return null
		
	var total_weight = 0
	for item in dict.keys():
		total_weight += dict[item].random_weight
		dict[item].accumulated_weight = total_weight
		
	var roll: int = randi_range(-fail_weight, total_weight)
	
	if roll < 0:
		dict.erase("accumulated_weight")
		return null
	
	for item in dict.keys():
		if dict[item].accumulated_weight >= roll:
			dict.erase("accumulated_weight")
			return dict[item]
	return null
			
static func just_pressed_from_list(input_arr: Array[String]):
	var any_valid = false;
	for input in input_arr:
		if Input.is_action_just_pressed(input):
			any_valid = true;
	return any_valid;
	
static func pressed_from_list(input_arr: Array[String]):
	var any_valid = false;
	for input in input_arr:
		if Input.is_action_pressed(input):
			any_valid = true;
	return any_valid;

static func convert_array_to_array2D(data: Array[Variant] = [true], column_count: int = 1):
	var shape_data: Array = [];	
	var curr_arr: Array = []
	shape_data.clear()
		
	for x in range(data.size()):
		curr_arr.append(data[x])
		if x % column_count == column_count - 1:
			shape_data.append(curr_arr.duplicate());
			curr_arr.clear();
	return shape_data;
	
static func flatten_hierarchy(node: Node, internal: bool = false) -> Array[Node]:
	var arr: Array[Node] = [];
	for c in node.get_children(internal):
		arr.append(c)
		if c.get_child_count() > 0:
			arr.append_array(flatten_hierarchy(c));
	return arr;
