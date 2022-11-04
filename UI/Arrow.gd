extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("cargo_ship_visibility_change", self, "_on_cargo_ship_visibility_change")

func _on_cargo_ship_visibility_change(visibility) -> void:
	if visibility:
		visible = false
	else:
		visible = true
