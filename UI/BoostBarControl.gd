extends Control

onready var boostBar = $BoostBar

var boost_bar_max_height = 0
var boost_bar_initial_position = 0

func _ready():
	boost_bar_max_height = boostBar.rect_size.y
	boost_bar_initial_position = boostBar.rect_position.y

func _physics_process(_delta):
	var boost_level = Globals.player_boost_level # This is always 100

	var boost_fraction = (boost_level/100)

	var fractional_height = int(boost_fraction * boost_bar_max_height)

	boostBar.rect_size.y = fractional_height
	boostBar.rect_position.y = boost_bar_initial_position + boost_bar_max_height - fractional_height
