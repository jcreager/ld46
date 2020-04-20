extends KinematicBody2D

var idle_timeout = 100 setget set_idle_timeout
var player_direction = "right" setget set_player_direction
var player_action = "" setget set_player_action
var facing = "right"
var start = Vector2(0,0)

export var velocity = Vector2(0, 0) setget set_velocity
# used to control move_and_slide to set velocity
export var control_velocity = Vector2(0, 0) setget set_control_velocity
export var speed = 0 setget set_speed
export var armor = 4 setget set_armor
export var move_range = Vector2(0,0) setget set_move_range

const tool_offset = {
	"left": Vector2(-8, 4),
	"right": Vector2(8, 4)
}

const projectile_velocity = {
	"left": Vector2(-10, 0),
	"right": Vector2(10, 0)
}

func set_velocity(new_value):
	velocity = new_value
	pass

func set_control_velocity(new_value):
	control_velocity = new_value
	pass

func set_speed(new_value):
	speed = new_value
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

func set_move_range(new_val):
	move_range = new_val
	pass

func _ready():
	set_process(true)
	add_to_group("enemy")
	$area.connect("area_entered", self, "_on_area_entered")
	start = position
	pass

func _physics_process(delta):
	_on_walking(player_direction)
	if idle_timeout > 0:
		idle_timeout -= 1
	else:
		_on_idle()
	if position.x > start.x + move_range.x:
		control_velocity.x = -control_velocity.x
		_on_walking("left")
		$sprite.flip_h = true
		$tool/weapon/sprite.flip_h = true
	if position.x < start.x:
		control_velocity.x = abs(control_velocity.x)
		_on_walking("right")
		$sprite.flip_h = false
		$tool/weapon/sprite.flip_h = false
	if position.y > start.y + move_range.y:
		control_velocity.y = -control_velocity.y
	if position.x < start.y:
		control_velocity.y = -control_velocity.y
	velocity = move_and_slide(Vector2(control_velocity.x * speed, control_velocity.y * speed), Vector2(0, 1))
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
	if !other.is_in_group("enemy"):
		other.get_parent().armor -= 1
	pass