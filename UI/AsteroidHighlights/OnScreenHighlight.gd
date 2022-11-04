extends Node2D

var following_object = null

func _physics_process(_delta):
	if is_instance_valid(following_object):
		if following_object.on_screen:
			global_position = following_object.global_position
			visible = true
		else:
			visible = false
	else:
		queue_free()
