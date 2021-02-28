extends KinematicBody2D

class_name Obstacle

var direction = Vector2.DOWN
var speed = 300

func _physics_process(delta):
	move_and_slide(direction * speed)
