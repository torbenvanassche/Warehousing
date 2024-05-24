extends Node3D

func _process(_delta):
	look_at(-Manager.camera.global_transform.origin, Vector3.UP)
