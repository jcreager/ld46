extends Node2D

const projectile = preload("res://weapons/projectile.tscn")

func _ready():
	pass

func _get_main_node():
	var root = get_tree().get_root()
	return root.get_child( root.get_child_count()-1 )
	pass

func fire(vel, pos):
	var new_projectile = projectile.instance()
	new_projectile.position = pos
	new_projectile.velocity = vel
	_get_main_node().get_child(0).add_child(new_projectile)
	pass