extends KinematicBody2D


class_name Brick

var target_pos = Vector2.ZERO
var is_moving = false
var speed = 100

func move_to_next_row():
	self.target_pos = self.position + Vector2(0, self.get_height())
	self.is_moving = true

func get_time_until_next_pos():
	return self.get_height() / self.speed

func get_width():
	return ($CollisionShape2D.shape.extents.x+2) * 2

func get_height():
	return ($CollisionShape2D.shape.extents.y+2) * 2

func _physics_process(delta):
	if not self.is_moving:
		return

	move_and_slide(self.position.direction_to(self.target_pos) * self.speed)
	if  self.position >= self.target_pos:
		self.position = self.target_pos
		self.is_moving = false
