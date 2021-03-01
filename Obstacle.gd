extends KinematicBody2D

class_name Obstacle

var direction = Vector2.DOWN
var speed = 1000

func _physics_process(delta):
	move_and_slide(direction * speed)
