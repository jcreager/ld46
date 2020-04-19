extends KinematicBody2D

var idle_timeout = 100 setget set_idle_timeout
var player_direction = "right" setget set_player_direction
var player_action = "" setget set_player_action
export var velocity = Vector2(0, 0) setget set_velocity

func set_velocity(new_value):
	velocity = new_value
	pass

func set_idle_timeout(new_value):
	idle_timeout = new_value
	pass

func set_player_direction(new_direction):
	player_direction = new_direction
	pass

func set_player_action(new_action):
	player_action = new_action
	pass

func _ready():
	set_process(true)
	pass

func _physics_process(delta):
	var velocity_x = 0
	var velocity_y = 0
	var speed = 0
	if idle_timeout > 0:
		idle_timeout -= 1
	else:
		_on_idle()
	if Input.is_action_pressed("player_left"):
		$sprite.flip_h = true
		velocity_x = -1
		speed = 100
		_on_walking("left")
	if Input.is_action_pressed("player_right"):
		$sprite.flip_h = false
		velocity_x = 1
		speed = 100
		_on_walking("right")
	if Input.is_action_pressed("player_up"):
		velocity_y = -1
		speed = 100
		_on_walking("up")
	if Input.is_action_pressed("player_down"):
		velocity_y = 1
		speed = 100
		_on_walking("down")
	velocity = move_and_slide(Vector2(velocity_x * speed, velocity_y * speed), Vector2(0, 1))
	pass

func _input(event):
	if (event.is_action_released("player_down")
	or event.is_action_released("player_up")
	or event.is_action_released("player_left")
	or event.is_action_released("player_right")):
		player_action = ""
		$animation.stop()
	pass

func _on_walking(new_direction):
	if player_action and player_action != new_direction: return
	player_action = new_direction
	player_direction = new_direction
	$animation.play("walking")
	idle_timeout = 5
	pass

func _on_idle():
	if idle_timeout > 0: return
	$animation.play("idle")
	pass