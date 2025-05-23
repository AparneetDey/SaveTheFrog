extends CanvasLayer

signal resume_game
signal music_toggle



func _on_continue_button_pressed() -> void:
	resume_game.emit()


func _on_toggle_button_toggled(toggled_on = false):
	if not toggled_on:
		$ToggleButton.text = "ON"
	else:
		$ToggleButton.text = "OFF"
	music_toggle.emit()
