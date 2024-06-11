class_name Interactable;
extends Node3D

@export var interaction: Interaction;
@export var static_body: StaticBody3D = null;
@export var interaction_distance: float = 1.5;

func _ready():
	if !interaction:
		printerr("No interaction is defined!")
		return;
	
	if !static_body:
		printerr("No static body assigned on " + self.name)
		return;
	static_body.input_event.connect(execute)

func execute(_camera = null, _event = null, _pos = Vector3.ZERO, _normal = Vector3.ZERO, _shape_idx = -1):
	Manager.player.use_navmesh = false;
	
	if !interaction.require_adjacent || Manager.player.is_near(self, interaction_distance):
		if _event.is_action_pressed("primary_click") && interaction:
			interaction.execute({"target": self});
