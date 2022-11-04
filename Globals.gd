extends Node

var player_global_position = Vector2.ZERO

const INITIAL_PLAYER_BOOST_LEVEL = 100
const INITIAL_LEVEL = 1

var player_boost_level = INITIAL_PLAYER_BOOST_LEVEL
var level = INITIAL_LEVEL

func _physics_process(_delta):
	Globals.player_boost_level = clamp(Globals.player_boost_level, 0, 100)

func reset():
	player_boost_level = INITIAL_PLAYER_BOOST_LEVEL
	level = INITIAL_LEVEL
