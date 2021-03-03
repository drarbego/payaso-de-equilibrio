extends KinematicBody2D

class_name Obstacle

var direction = Vector2.DOWN
var min_speed = 800
var max_speed = 1300
var min_x_extent = 20
var max_x_extent = 80
var speed = 0

func _ready():
	var shape = RectangleShape2D.new()
	var x_extent = (randi() % (max_x_extent - min_x_extent + 1)) + min_x_extent
	shape.set_extents(Vector2(x_extent, 80))
	$CollisionShape2D.set_shape(shape)

	self.speed = ((float(max_x_extent) - float(x_extent)) / float(max_x_extent)) * (max_speed - min_speed) + min_speed

func _physics_process(delta):
	move_and_slide(direction * speed)
