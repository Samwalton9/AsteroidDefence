extends StaticBody2D

const SHIP_MAX_HEALTH = 4

var health = 4

signal cargo_ship_dead()

func _on_AsteroidCollisionArea_area_entered(area):
	health -= 1

	Events.emit_signal("cargo_ship_hp_update", health)

	# Destroy the asteroid
	area.get_parent().queue_free()

	if health < 1:
		emit_signal("cargo_ship_dead")


func _on_VisibilityNotifier2D_screen_entered():
	Events.emit_signal("cargo_ship_visibility_change", true)


func _on_VisibilityNotifier2D_screen_exited():
	Events.emit_signal("cargo_ship_visibility_change", false)
