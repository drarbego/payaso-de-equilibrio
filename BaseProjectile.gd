extends KinematicBody2D

class_name Projectile

var speed = 2500
var dir = Vector2.UP

func _physics_process(delta):
	var velocity = dir * speed * delta
	var collision = move_and_collide(velocity)

	if collision:
		dir = dir.bounce(collision.normal)
