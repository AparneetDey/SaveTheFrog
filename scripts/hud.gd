extends CanvasLayer

signal start_game

var parent := get_parent()

func _ready() -> void:
	$controlGuide.hide()
	$MobileButton.hide()

func show_message(text):
	$message.text = text
	$message.show()
	$messageTimer.start()
	
func show_game_over():
	show_message("Game Over!")
	$controlGuide.hide()
	$MobileButton.hide()
	
	await $messageTimer.timeout
	
	$message.text = "Save The Frog!!"
	$message.show()
	
	await get_tree().create_timer(1.0).timeout
	
	$startButton.show()
	
func update_score(score):
	$scoreLabel.text = str(score)

func _on_start_button_pressed():
	$startButton.hide()
	start_game.emit()
	
	if (parent as parentScript).is_mobile_web():
		$MobileButton.show()
	else:
		$controlGuide.show()


func _on_message_timer_timeout() -> void:
	$message.hide()
