class_name Carryable
extends Node

var size: Vector2i;
var current: BoxData;

func _init(s: Vector2i = Vector2i(1, 1), box: BoxData = BoxData.new()):
	self.size = s;
	self.current = box;
