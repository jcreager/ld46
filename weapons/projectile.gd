extends KinematicBody2D

export var velocity = Vector2()

func _ready(): 
	set_process(true)
	connect("area_entered", self, "_on_area_entered")
	pass

func _physics_process(delta):
	var collision
	rotation = velocity.angle()
	collision = move_and_collide(velocity)
	pass

func _on_area_entered(other):
	queue_free()
	pass