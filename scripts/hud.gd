extends CanvasLayer

signal start_game

func _ready() -> void:
	$controlGuide1.hide()
	$controlGuide2.hide()

func show_message(text):
	$message.text = text
	$message.show()
	$messageTimer.start()
	
func show_game_over():
	show_message("Game Over!")
	$controlGuide1.hide()
	$controlGuide2.hide()
	
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
	$controlGuide1.show()
	$controlGuide2.show()


func _on_message_timer_timeout() -> void:
	$message.hide()
