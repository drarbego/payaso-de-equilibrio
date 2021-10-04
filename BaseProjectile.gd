extends KinematicBody2D

class_name Projectile

export (float) var max_speed = 2500
var speed = max_speed
var speed_decrease = 300
var dir = Vector2.UP

func _physics_process(delta):
	var velocity = dir * speed * delta
	var collision = move_and_collide(velocity)

	if collision:
		dir = dir.bounce(collision.normal)
		if collision.collider is Brick:
			collision.collider.queue_free()
