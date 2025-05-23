extends Area2D
signal hit

@export var speed = 250 #Max speed

@export var dash_speed = 500 #Dashing speed
const dash_duration = 0.3
const dash_cooldown = 1.0

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO

var input = Vector2.ZERO #Direction of object to move
var velocity = Vector2.ZERO #Object's velocity
var target_position = Vector2.ZERO #Targeted position for object to move

var screen_size
var min_bound
var max_bound

var is_game_started = false

func _ready():
	screen_size = get_viewport_rect().size #Calculating Screen size
	var body_shape = $CollisionShape2D.shape #Caluclation size of Collision/Body
	var width = body_shape.radius * 2
	var height = body_shape.height + body_shape.radius*2
	var body_size = Vector2(width,height)
	
	#Setting min and max bound
	min_bound = Vector2.ZERO + body_size/4
	max_bound = screen_size  - body_size/4
	
	target_position = position #Default psoition to target

func _input(event):
	if is_game_started:
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT: #Left mouse click to set a direction for object to move
			target_position = get_global_mouse_position() #getting mouse clicked coordinates
			input = (target_position - position).normalized() #setting direction of target with respect to current position
			if input.length() != 0:
				velocity = input*speed
			
			var ripple = preload("res://scenes/ripple.tscn").instantiate()
			ripple.global_position = target_position
			get_tree().current_scene.add_child(ripple)
			
			$RippleEffect.play()
		
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT and not is_dashing and dash_cooldown_timer <= 0.0: #Rigth mouse click for object to dash
			is_dashing = true
			dash_timer = dash_duration
			dash_cooldown_timer = dash_cooldown
			dash_direction = velocity.normalized() #Das direction is the direction the object is moving
			
			$DashEffect.play()

func _process(delta):
	
	if dash_cooldown_timer>0.0:
		dash_cooldown_timer -= delta #Dash cooldown
		
	if is_dashing: #Dashing logic
		velocity = dash_direction*dash_speed
		dash_timer -= delta
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("dash")
		if dash_timer<=0.0:
			is_dashing = false
			velocity = velocity.normalized()*speed #Returning to normal speed
	
	if not is_dashing: #Do not bounce in boundary when dashing
		if position.x <= min_bound.x or position.x >= max_bound.x:
			velocity.x *= -1
		if position.y <= min_bound.y or position.y >= max_bound.y:
			velocity.y *= -1

	if velocity.length() != 0 and !is_dashing:
		$AnimatedSprite2D.play("swim")
		$AnimatedSprite2D.rotation = velocity.angle() + PI/2

	position += velocity*delta
	position = position.clamp(min_bound, max_bound)

func start(pos):
	position = pos
	target_position = position
	velocity = Vector2.ZERO
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
