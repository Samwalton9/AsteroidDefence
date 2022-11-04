extends Control

onready var OffScreenIndicator = preload("res://UI/AsteroidHighlights/OffScreenIndicator.tscn")

onready var arrow = $Arrow

func _ready() -> void:
	Events.connect("asteroid_on_collision_course", self, "_on_asteroid_on_collision_course")


func _physics_process(_delta) -> void:
	# Update locations/angles of existing elements
	var active_indicators = get_tree().get_nodes_in_group("active_indicators")
	
	for indicator in active_indicators:
		if is_instance_valid(indicator.asteroid):
			var asteroid_direction = indicator.asteroid.get_angle_from_player()
			indicator.arrow_angle = asteroid_direction + 180 # Arrow starts on the left side

			indicator.rect_position = Vector2(1000,0).rotated(deg2rad(asteroid_direction)) + rect_size/2

			indicator.rect_position.x = clamp(indicator.rect_position.x, 0, rect_size.x)
			indicator.rect_position.y = clamp(indicator.rect_position.y, 0, rect_size.y)
		else:
			indicator.queue_free()

	var cargo_ship_direction = -Globals.player_global_position
	var cargo_ship_angle = rad2deg(cargo_ship_direction.angle())
	arrow.rotation_degrees = cargo_ship_angle - 90 # Points down initially
	arrow.position = Vector2(1000,0).rotated(deg2rad(cargo_ship_angle)) + rect_size/2
	arrow.position.x = clamp(arrow.position.x, 0, rect_size.x)
	arrow.position.y = clamp(arrow.position.y, 0, rect_size.y)


func _on_asteroid_on_collision_course(asteroid_node) -> void:
	# Create a new UI element
	var indicator = OffScreenIndicator.instance()
	add_child(indicator)

	indicator.asteroid = asteroid_node
	indicator.add_to_group("active_indicators")
