extends KinematicBody2D

var idle_timeout = 100 setget set_idle_timeout
var player_direction = "right" setget set_player_direction
var player_action = "" setget set_player_action
var facing = "right"

export var velocity = Vector2(0, 0) setget set_velocity
export var armor = 4 setget set_armor

const tool_offset = {
	"left": Vector2(-8, 4),
	"right": Vector2(8, 4)
}

const projectile_velocity = {
	"left": Vector2(-500, 0),
	"right": Vector2(500, 0)
}

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

func set_armor(new_val):
	armor = new_val
	if armor <= 0:
		queue_free()
	pass

func _ready():
	set_process(true)
	add_to_group("player")
	$area.connect("area_entered", self, "_on_area_entered")
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
		$tool/weapon/sprite.flip_h = true
		velocity_x = -1
		speed = 100
		_on_walking("left")
	if Input.is_action_pressed("player_right"):
		$sprite.flip_h = false
		$tool/weapon/sprite.flip_h = false
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
	if event.is_action_pressed("attack"):
		$tool/weapon.fire(
			projectile_velocity[facing], 
			$tool/weapon/barrel.global_position
		)
	pass

func _on_walking(new_direction):
	if player_action and player_action != new_direction: return
	player_action = new_direction
	player_direction = new_direction
	if player_direction == "left" or player_direction == "right":
		facing = new_direction
		$tool.position = tool_offset[new_direction]
	$animation.play("walking")
	idle_timeout = 5
	pass

func _on_idle():
	if idle_timeout > 0: return
	$animation.play("idle")
	pass

func _on_area_entered(other):
	if other.is_in_group("enemy"):
		other.get_parent().armor -= 1
	pass