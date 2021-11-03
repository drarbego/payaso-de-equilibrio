extends KinematicBody2D


class_name Brick

const Obstacle = preload("res://Obstacle.tscn")

var target_pos = Vector2.ZERO
var is_moving = false
var speed = 100
var is_aggresive = false
const MAX_TIME = 5
const MIN_TIME = 2

func _ready():
	if self.is_aggresive:
		self.start_timer()
		$Polygon2D.color = Color.red

func start_timer():
	$ObstacleTimer.wait_time = (MAX_TIME - MIN_TIME) * randf() + MIN_TIME
	$ObstacleTimer.start()

func _on_ObstacleTimer_timeout():
	self.spawn_obstacle()
	self.start_timer()

func spawn_obstacle():
	var obstacle = Obstacle.instance().init(self.global_position)
	get_node("../../Obstacles").add_child(obstacle)

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
