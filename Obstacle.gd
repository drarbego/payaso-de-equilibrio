extends KinematicBody2D

class_name Obstacle

var direction = Vector2.DOWN
var min_speed = 800
var max_speed = 1300
var min_x_extent = 20
var max_x_extent = 80
var speed = 0

signal destroyed(points)

func init(global_pos: Vector2):
	self.global_position = global_pos

	return self

func _ready():
	self.speed = (max_speed - min_speed) * randf() + min_speed

func _on_Hitbox_body_entered(body):
	if body is Projectile:
		$CollisionShape2D.set_deferred('disabled', true)
		self.destroy()

func destroy():
	var points = ceil((self.speed / self.max_speed) * 100)
	emit_signal("destroyed", points)
	self.queue_free()

func _physics_process(delta):
	move_and_slide(direction * speed)
