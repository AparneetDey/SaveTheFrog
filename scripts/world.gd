extends Node

@export var mob_scene: PackedScene
var score
var game_started = false

func _ready() -> void:
	$Music.play()
	$Player.hide()
	$PauseMenu.hide()

func game_over():
	$scoreTimer.stop()
	$mobTimer.stop()
	$HUD.show_game_over()
	$Player.is_game_started = false
	game_started = false
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($startPosition.position)
	$startTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	get_tree().call_group("mobs","queue_free")
	$Player.is_game_started = true
	$Player/AnimatedSprite2D.play("idle")
	$Player/AnimatedSprite2D.rotation = 0


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $mobPath/mobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI/2
	
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction + PI/2
	
	var velocity
	if score>=0 and score<30:
		velocity = Vector2(randf_range(200.0, 300.0),0.0)
	elif score>=30 and score<60:
		velocity = Vector2(randf_range(250.0, 350.0),0.0)
	elif score>=60 and score<120:
		velocity = Vector2(randf_range(300.0, 400.0),0.0)
	else:
		velocity = Vector2(randf_range(400.0, 600.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	if score>=0 and score<45:
		$mobTimer.wait_time = 0.75
	elif score>=45 and score<90:
		$mobTimer.wait_time = 0.5
	else:
		$mobTimer.wait_time = 0.25
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and game_started:
		get_tree().paused = not get_tree().paused
		$PauseMenu.show()

func _on_start_timer_timeout() -> void:
	$scoreTimer.start()
	$mobTimer.start()
	game_started = true


func _on_pause_menu_resume_game() -> void:
	$PauseMenu.hide()
	
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = not get_tree().paused


func _on_pause_menu_music_toggle() -> void:
	$Music.stream_paused = not $Music.stream_paused
