extends Node2D

const ASTEROID_SPAWN_DISTANCE = 2500

onready var asteroid_time_min = 1
onready var asteroid_time_max = 2

onready var asteroidTimer = $AsteroidTimer

onready var asteroid = preload("res://Asteroids/Asteroid.tscn")


func _ready():
	randomize()

	# warning-ignore:return_value_discarded
	Events.connect("difficulty_increase", self, "_on_difficulty_increase")

	$CargoShip.connect("cargo_ship_dead", self, "_on_cargo_ship_dead")


func _physics_process(_delta):
	$ColorRect.rect_global_position = Globals.player_global_position
	$ColorRect.rect_global_position -= $ColorRect.rect_size/2


func _on_AsteroidTimer_timeout():
	var new_asteroid = asteroid.instance()

	var random_pos = Vector2(rand_range(-1,1), rand_range(-1,1))
	var spawn_location = random_pos.normalized() * ASTEROID_SPAWN_DISTANCE

	add_child(new_asteroid)
	new_asteroid.set_spawn_parameters(spawn_location)

	asteroidTimer.wait_time = rand_range(asteroid_time_min, asteroid_time_max)


func _on_difficulty_increase() -> void:
	asteroid_time_min = clamp(asteroid_time_min - 0.1, 0.1, 1)
	asteroid_time_max = clamp(asteroid_time_max - 0.1, 0.3, 2)

func _on_cargo_ship_dead():
	get_tree().change_scene("res://Menus/GameOver.tscn")
