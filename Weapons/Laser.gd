extends Area2D

onready var LASER_SPEED = 1400

onready var laserTimer = $LaserTimer

func _physics_process(delta):
	global_position += Vector2(0,-1).rotated(deg2rad(rotation_degrees)) * LASER_SPEED * delta


func _on_Laser_area_entered(_area):
	queue_free()


func _on_LaserTimer_timeout():
	queue_free()
