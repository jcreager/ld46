extends KinematicBody2D

export var velocity = Vector2()
export var speed = 500

var control_velocity = Vector2(0,0)
var timer = 5

func _ready(): 
	set_process(true)
	add_to_group("projectile")
	$area.connect("area_entered", self, "_on_area_entered")
	control_velocity = velocity
	pass

func _physics_process(delta):
	rotation = velocity.angle()
	velocity = move_and_slide(Vector2(control_velocity.x * speed, control_velocity.y * speed), Vector2(0, 1))
	if velocity.x == 0 and velocity.y == 0:
		timer -= 1
		if timer == 0:
			queue_free()
	yield(get_node("visable"), "screen_exited")
	queue_free()
	pass

func _on_area_entered(other):
	if other.get_parent().is_in_group("projectile"):
		return
	other.get_parent().armor -= 1
	queue_free()
	pass
