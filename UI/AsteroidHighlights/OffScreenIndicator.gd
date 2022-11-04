extends Control

export(int) var arrow_distance = 85
export(float) var arrow_angle = 0.0

onready var arrow = $Arrow

var asteroid = null

func _physics_process(_delta):
	arrow.position = Vector2(-arrow_distance, 0).rotated(deg2rad(arrow_angle)) # Starts on left
	arrow.rotation_degrees = arrow_angle

	if is_instance_valid(asteroid):
		if asteroid.on_screen:
			visible = false
		else:
			visible = true

		var distance_to_ship = asteroid.distance_to_cargo_ship()
		$DistanceLabel.text = str(int(distance_to_ship))
