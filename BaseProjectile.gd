extends KinematicBody2D

class_name Projectile

export (float) var max_speed = 1000
var speed = max_speed
var speed_decrease = 300
export (float) var gravity_speed = 500
var dir = Vector2.UP

func _physics_process(delta):
	var gravity = Vector2.DOWN * gravity_speed * delta
	var velocity = dir * speed * delta
	var collision = move_and_collide(velocity + gravity)
	speed = clamp(speed - speed_decrease * delta, 0, max_speed)

	if collision:
		dir = dir.bounce(collision.normal)

		if collision.collider is Player:
			collision.collider.increase_bullets()
			self.queue_free()
		if collision.collider is Obstacle:
			collision.collider.destroy()
