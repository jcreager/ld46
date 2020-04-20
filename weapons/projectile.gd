extends KinematicBody2D

export var velocity = Vector2()

func _ready(): 
	set_process(true)
	$area.connect("area_entered", self, "_on_area_entered")
	pass

func _physics_process(delta):
	rotation = velocity.angle()
	var collision = move_and_collide(velocity * delta)
	yield(get_node("visable"), "screen_exited")
	queue_free()
	pass

func _on_area_entered(other):
	print("hit")
	other.get_parent().armor -= 1
	queue_free()
	pass
