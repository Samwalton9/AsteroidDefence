extends CanvasLayer

onready var GameTimer = $GameTimer


func _on_GameTimer_timeout():
	Events.emit_signal("difficulty_increase")

	Globals.level += 1
	$LevelLabel.text = "Level: " + str(Globals.level)
