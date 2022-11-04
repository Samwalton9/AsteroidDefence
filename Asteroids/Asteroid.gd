extends StaticBody2D

const ASTEROID_SPEED_MIN = 50
const ASTEROID_SPEED_MAX = 150

const ROTATION_SPEED_MIN = -0.5
const ROTATION_SPEED_MAX = 0.5

const ASTEROID_HP_MIN = 0 # Actually 1 since we round up.
const ASTEROID_HP_MAX = 3

const ASTEROID_SCALE_MIN = 0.6
const ASTEROID_SCALE_MAX = 1.2

var direction = Vector2(0,0)
var move_speed = 0
var spin_speed = 0
var scale_factor = 1
var health = 1

var on_screen = false

onready var OnScreenHighlight = preload("res://UI/AsteroidHighlights/OnScreenHighlight.tscn")


func _physics_process(delta) -> void:
	global_position += direction * move_speed * delta
	rotation_degrees += spin_speed

	if global_position.length() > 3000:
		queue_free()


func set_spawn_parameters(spawn_position : Vector2) -> void:
	global_position = spawn_position
	var direction_to_origin = global_position.direction_to(Vector2(0,0))

	var random_angle = rand_range(-25,25)
	direction = direction_to_origin.rotated(deg2rad(random_angle))

	move_speed = rand_range(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX)
	spin_speed = rand_range(ROTATION_SPEED_MIN, ROTATION_SPEED_MAX)

	# Scale and health are correlated, using the same random number.
	var random_size = randf()

	scale_factor = (random_size * (ASTEROID_SCALE_MAX - ASTEROID_SCALE_MIN)) + ASTEROID_SCALE_MIN
	scale = Vector2(scale_factor, scale_factor)

	health = int(ceil((random_size * (ASTEROID_HP_MAX - ASTEROID_HP_MIN)) + ASTEROID_HP_MIN))

	check_if_on_collision_course()


func check_if_on_collision_course():
	if is_on_collision_course():
		Events.emit_signal("asteroid_on_collision_course", self)
		add_to_group("ui_asteroids")

		var onScreenHighlight = OnScreenHighlight.instance()
		onScreenHighlight.following_object = self
		get_tree().get_root().add_child(onScreenHighlight)


func is_on_collision_course() -> bool:
	for raycast in [$RayCasts/RayCast1, $RayCasts/RayCast2, $RayCasts/RayCast3, $RayCasts/RayCast4]:
		raycast.cast_to = direction * 5000 # Arbitrary point in the direction of travel.
		raycast.force_raycast_update() # We're only checking during this frame.

		if raycast.is_colliding():
			return true 
	return false


func get_angle_from_player() -> float:
	var angle = rad2deg(global_position.angle_to_point(Globals.player_global_position))
	return angle


func distance_to_cargo_ship() -> float:
	return global_position.length()


func _on_LaserHitArea_area_entered(_area) -> void:
	if health != 1:
		var split_one = self.duplicate()
		var split_two = self.duplicate()
		var random_angle = rand_range(10, 50)

		for new_asteroid in [split_one, split_two]:
			new_asteroid.direction = direction
			new_asteroid.move_speed = move_speed * 0.75
			new_asteroid.spin_speed = spin_speed * 1.5
			new_asteroid.scale = scale * 0.7
			new_asteroid.health = health - 1
			new_asteroid.rotation_degrees = 0
			get_parent().call_deferred("add_child", new_asteroid)

		split_one.direction = split_one.direction.rotated(deg2rad(random_angle))
		split_one.call_deferred("check_if_on_collision_course")

		split_two.direction = split_two.direction.rotated(deg2rad(-random_angle))
		split_two.call_deferred("check_if_on_collision_course")

	# Either way the original is destroyed
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
