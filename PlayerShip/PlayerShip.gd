extends KinematicBody2D

export(int) onready var ACCELERATION = 800
export(int) onready var FRICTION = 100

export(int) onready var MOVE_MAX_SPEED = 400
export(int) onready var BOOST_MAX_SPEED = 800

export(int) onready var MOVE_TURN_SPEED = 2
export(int) onready var BOOST_TURN_SPEED = 1

const COLLIDE_SPEED = 100

var velocity = Vector2.ZERO

onready var Laser = preload("res://Weapons/Laser.tscn")
onready var shipSprite = $ShipSprite
onready var camera = $Camera2D

var boost_drain_speed = 40
var boost_build_speed = 10

enum {
	MOVE,
	BOOST,
	COLLISION
}

onready var state = MOVE
var turn_speed = MOVE_TURN_SPEED
var max_speed = MOVE_MAX_SPEED

func _physics_process(delta):
	check_state()

	match state:
		MOVE:
			move_state(delta)
		BOOST:
			boost_state(delta)
		COLLISION:
			collide_state(delta)

	if Input.is_action_just_pressed("shoot"):
		shoot_weapon()

	Globals.player_global_position = global_position


func check_state():

	process_collisions()

	if not $CollideTimer.is_stopped():
		state = COLLISION
	elif Input.is_action_pressed("boost") and $BoostTimer.is_stopped():
		state = BOOST
	else:
		state = MOVE


func move_state(delta) -> void:
	turn_speed = MOVE_TURN_SPEED
	max_speed = MOVE_MAX_SPEED

	var input_vector = get_input_vector()

	Globals.player_boost_level += boost_build_speed * delta

	process_player_movement(input_vector, delta)


func boost_state(delta) -> void:
	turn_speed = BOOST_TURN_SPEED
	max_speed = BOOST_MAX_SPEED

	var input_vector = Vector2(0,-1)

	if is_zero_approx(Globals.player_boost_level):
		$BoostTimer.start()
	else:
		Globals.player_boost_level -= boost_drain_speed * delta

	camera.shake_camera(0.03)

	process_player_movement(input_vector, delta)


func collide_state(delta) -> void:
	velocity = velocity.normalized() * COLLIDE_SPEED
	velocity = move_and_slide(velocity)


func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	return input_vector


func process_player_movement(input_vector, delta) -> void:
	var rotation_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if rotation_strength > 0:
		rotation_degrees += turn_speed
	elif rotation_strength < 0:
		rotation_degrees -= turn_speed

	if input_vector != Vector2.ZERO:
		var target_speed = input_vector * max_speed
		target_speed = target_speed.rotated(deg2rad(rotation_degrees))
		# If I want this to feel less wooden, use speed clamping instead of move_toward
		velocity = velocity.move_toward(target_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	if state == BOOST:
		shipSprite.frame = 3
	elif input_vector.y == 1:
		shipSprite.frame = 2
	elif input_vector.y == -1:
		shipSprite.frame = 1
	else:
		shipSprite.frame = 0

	velocity = move_and_slide(velocity)


func shoot_weapon() -> void:
	var laser = Laser.instance()
	var world_scene = get_parent()

	world_scene.add_child(laser)
	laser.global_position = global_position + Vector2(0,-30).rotated(rotation)
	laser.rotation_degrees = rotation_degrees

	camera.shake_for_time(0.1)

	# Laser then controls itself


func process_collisions() -> bool:
	if get_slide_count() != 0:
		camera.shake_for_time(0.3)
		$CollideTimer.start()

		var collision = get_slide_collision(0)
		if is_instance_valid(collision.collider):
			var coll_position = collision.collider.position

			var collide_direction = position.direction_to(coll_position)
			velocity = velocity.bounce(collide_direction)

		return true
	else:
		return false


func _on_CollideTimer_timeout():
	state = MOVE
