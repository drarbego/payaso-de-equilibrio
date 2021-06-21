extends KinematicBody2D

class_name Obstacle

var direction = Vector2.DOWN
var min_speed = 800
var max_speed = 1300
var min_x_extent = 20
var max_x_extent = 80
var speed = 0

signal destroyed(points)

func _on_Hitbox_body_entered(body):
	if body is Projectile:
		$CollisionShape2D.set_deferred('disabled', true)
		self.destroy()

func _ready():
	var shape = RectangleShape2D.new()
	var x_extent = (randi() % (max_x_extent - min_x_extent + 1)) + min_x_extent
	var y_extent = 80
	shape.set_extents(Vector2(x_extent, y_extent))
	$CollisionShape2D.set_shape(shape)
	var top_left = Vector2(-shape.extents.x, -shape.extents.y)
	var top_right = Vector2(shape.extents.x, -shape.extents.y)
	var bottom_left = Vector2(-shape.extents.x, shape.extents.y)
	var bottom_right = Vector2(shape.extents.x, shape.extents.y)
	$Polygon2D.polygon = PoolVector2Array([top_left, top_right, bottom_right, bottom_left])

	self.speed = ((float(max_x_extent) - float(x_extent)) / float(max_x_extent)) * (max_speed - min_speed) + min_speed

func destroy():
	var points = ceil((self.speed / self.max_speed) * 100)
	emit_signal("destroyed", points)
	self.queue_free()

func _physics_process(delta):
	move_and_slide(direction * speed)
