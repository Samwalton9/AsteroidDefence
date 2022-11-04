extends Control

onready var hitTimer = $HitTimer
onready var shakeTimer = $ShakeTimer

onready var original_rect_position = rect_position

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("cargo_ship_hp_update", self, "_on_cargo_ship_hp_update")


func _physics_process(delta):
	if not hitTimer.is_stopped() and shakeTimer.is_stopped():
		shakeTimer.start()


func _on_cargo_ship_hp_update(health):
	$AnimatedSprite.frame = health
	hitTimer.start()


func shake_bars(strength) -> void:
	rect_position.x = original_rect_position.x + rand_range(0, strength)
	rect_position.y = original_rect_position.y + rand_range(0, strength)


func _on_ShakeTimer_timeout():
	shake_bars(10)


func _on_HitTimer_timeout():
	rect_position = original_rect_position # This doesn't work. I think it times before the other one.
