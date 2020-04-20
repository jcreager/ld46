extends Node2D

const projectile = preload("res://weapons/projectile.tscn")

func _ready():
	#create_projectile(Vector2(0.1, 0), $barrel.position)
	pass

func fire(vel, pos):
	var new_projectile = projectile.instance()
	new_projectile.position = pos
	new_projectile.velocity = vel
	$barrel.add_child(new_projectile)
	pass