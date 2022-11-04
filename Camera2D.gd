extends Camera2D

var shake_strength = 0.02


func _physics_process(_delta):
	if not $ShakeTimer.is_stopped():
		shake_camera(shake_strength)


func shake_camera(strength) -> void:
	offset_h = rand_range(0, strength)
	

func reset_camera() -> void:
	offset_h = 0
	offset_v = 0


func shake_for_time(time) -> void:
	if $ShakeTimer.is_stopped():
		$ShakeTimer.wait_time = time
		$ShakeTimer.start()
