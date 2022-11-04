extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$FinalScoreLabel.text = "Final score: " + str(Globals.level)


func _on_Button_pressed():
	Globals.reset()
	get_tree().change_scene("res://World.tscn")
